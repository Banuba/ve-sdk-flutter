package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.Intent
import android.net.Uri
import android.util.Log
import com.banuba.sdk.cameraui.data.PipConfig
import com.banuba.sdk.core.license.BanubaVideoEditor
import com.banuba.sdk.export.data.ExportResult
import com.banuba.sdk.export.utils.EXTRA_EXPORTED_SUCCESS
import com.banuba.sdk.ve.flow.VideoCreationActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.io.File
import android.os.Bundle
import org.json.JSONObject
import org.json.JSONException
import androidx.core.os.bundleOf
import com.banuba.sdk.veui.data.captions.CaptionsApiService

class VeSdkFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
    companion object {
        private const val TAG = "VideoEditorPlugin"

        private const val VIDEO_EDITOR_REQUEST_CODE = 1000
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var currentActivity: Activity? = null

    private var editorSDK: BanubaVideoEditor? = null
    private var videoEditorModule: VideoEditorModule? = null

    private var channelResult: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        inputResult: Result
    ) {
        channelResult = inputResult

        val methodName = call.method
        Log.d(TAG, "Received method call = $methodName")

        val licenseToken = call.argument<String>(INPUT_PARAM_TOKEN)
        if (licenseToken.isNullOrEmpty()) {
            channelResult?.error(ERR_INVALID_PARAMS, ERR_MESSAGE_MISSING_TOKEN, null)
            return
        }

        val androidConfig = getAndroidConfig(call.argument<String>(INPUT_PARAM_CONFIG))

        val screen = call.argument<String>(INPUT_PARAM_SCREEN)
        if (screen.isNullOrEmpty()) {
            channelResult?.error(ERR_INVALID_PARAMS, ERR_MESSAGE_MISSING_SCREEN, null)
            return
        }

        when (methodName) {
            METHOD_START -> {
                initialize(licenseToken, androidConfig) { activity ->
                    val extras = createExtras(androidConfig)
                    val intent = when (screen) {
                        SCREEN_CAMERA -> {
                            Log.d(TAG, "Start video editor from camera screen")
                            VideoCreationActivity.startFromCamera(
                                context = activity,
                                // setup data that will be acceptable during export flow
                                additionalExportData = null,
                                // set TrackData object if you open VideoCreationActivity with preselected music track
                                audioTrackData = null,
                                // set PiP video configuration
                                pictureInPictureConfig = PipConfig(
                                    video = Uri.EMPTY,
                                    openPipSettings = false
                                ),
                                extras = extras
                            )
                        }
                        SCREEN_PIP -> {
                            val videoSources =
                                call.argument<List<String>>(INPUT_PARAM_VIDEO_SOURCES)
                            Log.d(TAG, "Received pip video sources = $videoSources")

                            if (videoSources.isNullOrEmpty()) {
                                channelResult?.error(
                                    ERR_INVALID_PARAMS,
                                    ERR_MESSAGE_MISSING_PIP_VIDEO,
                                    null
                                )
                                return@initialize
                            }

                            val videoUri = Uri.fromFile(File(videoSources.first()))
                            Log.d(TAG, "Start video editor in pip mode with video = $videoUri")

                            VideoCreationActivity.startFromCamera(
                                context = activity,
                                // setup data that will be acceptable during export flow
                                additionalExportData = null,
                                // set TrackData object if you open VideoCreationActivity with preselected music track
                                audioTrackData = null,
                                // set PiP video configuration
                                pictureInPictureConfig = PipConfig(
                                    video = videoUri,
                                    openPipSettings = false
                                )
                            )
                        }

                        SCREEN_TRIMMER -> {
                            val videoSources =
                                call.argument<List<String>>(INPUT_PARAM_VIDEO_SOURCES)
                            Log.d(TAG, "Received trimmer video sources = $videoSources")

                            if (videoSources.isNullOrEmpty()) {
                                channelResult?.error(
                                    ERR_INVALID_PARAMS,
                                    ERR_MESSAGE_MISSING_TRIMMER_VIDEO_SOURCES,
                                    null
                                )
                                return@initialize
                            }

                            VideoCreationActivity.startFromTrimmer(
                                context = activity,
                                // setup data that will be acceptable during export flow
                                additionalExportData = null,
                                // set TrackData object if you open VideoCreationActivity with preselected music track
                                audioTrackData = null,
                                // set Trimmer video configuration
                                predefinedVideos = videoSources.map { Uri.fromFile(File(it)) }
                                    .toTypedArray(),
                                extras = extras
                            )
                        }

                        else -> null
                    }

                    if (intent == null) {
                        Log.e(TAG, "Cannot start: unknown screen = $screen")
                        channelResult?.error(ERR_INVALID_PARAMS, ERR_MESSAGE_UNKNOWN_SCREEN, null)
                        return@initialize
                    }

                    activity.startActivityForResult(intent, VIDEO_EDITOR_REQUEST_CODE)
                }
            }

            else -> {
                Log.e(TAG, "Unhandled method call = $methodName")
                channelResult?.notImplemented()
            }
        }
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        intent: Intent?
    ): Boolean {
        Log.d(TAG, "onActivityResult: code = $resultCode, result = $resultCode, intent = $intent")

        return if (requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            val data = if (resultCode == RESULT_OK) {
                val exportResult =
                    intent?.getParcelableExtra(EXTRA_EXPORTED_SUCCESS) as? ExportResult.Success
                Log.d(TAG, "Received export result = $exportResult")

                if (exportResult == null) {
                    this.channelResult?.error(
                        ERR_MISSING_EXPORT_RESULT,
                        ERR_MESSAGE_MISSING_EXPORT_RESULT,
                        null
                    )
                    return false
                }

                prepareVideoExportData(exportResult)
            } else {
                Log.d(TAG, "No export result: the user closed video editor")
                null
            }
            this.channelResult?.success(data)
            true
        } else {
            Log.e(TAG, "Unhandled request code = $requestCode")
            false
        }
    }

    // Customize export data results to meet your requirements.
    // You can use Map or JSON to pass custom data for your app.
    private fun prepareVideoExportData(result: ExportResult.Success): Map<String, Any?> {
        val videoSources = result.videoList.map { it.sourceUri.toString() }
        val previewPath = result.preview.toString()
        val data = mapOf(
            EXPORTED_VIDEO_SOURCES to videoSources,
            EXPORTED_PREVIEW to previewPath,
            EXPORTED_META to result.metaUri.toString()
        )
        return data
    }

    private fun initialize(
        token: String,
        androidConfig: AndroidConfig?,
        block: (Activity) -> Unit
    ) {
        val activity = currentActivity

        if (activity == null) {
            Log.e(TAG, ERR_MESSAGE_MISSING_HOST)
            channelResult?.error(ERR_MISSING_HOST, ERR_MESSAGE_MISSING_HOST, null)
            return
        }

        val sdk = BanubaVideoEditor.initialize(token)

        if (sdk == null) {
            // The SDK token is incorrect - empty or truncated
            Log.e(TAG, ERR_MESSAGE_SDK_NOT_INITIALIZED)
            channelResult?.error(
                ERR_CODE_SDK_NOT_INITIALIZED,
                ERR_MESSAGE_SDK_NOT_INITIALIZED,
                null
            )
            return
        }
        if (videoEditorModule == null) {
            // Initialize video editor sdk dependencies
            videoEditorModule = VideoEditorModule().apply {
                initialize(activity.application, androidConfig)
            }
        }

        editorSDK = sdk

        sdk.getLicenseState { isValid ->
            if (isValid) {
                Log.d(TAG, "The license token is valid!")
                block(activity)
            } else {
                Log.e(TAG, ERR_MESSAGE_LICENSE_REVOKED)
                channelResult?.error(
                    ERR_CODE_SDK_LICENSE_REVOKED,
                    ERR_MESSAGE_LICENSE_REVOKED,
                    null
                )
            }
        }
    }

    private fun getAndroidConfig(androidConfigJson: String?): AndroidConfig? {
        return androidConfigJson?.let {
            try {
                val jsonObject = JSONObject(androidConfigJson)

                val aiClipping = prepareAiClipping(jsonObject)
                val aiCaptions = prepareAiCaptions(jsonObject)
                val audioBrowser = prepareAudioBrowser(jsonObject)

                val androidConfig = AndroidConfig(aiClipping, aiCaptions, audioBrowser)
                return androidConfig
            } catch (e: JSONException){
                Log.d(TAG, ERR_MESSAGE_INVALID_CONFIG, e)
                null
            }
        }
    }

    private fun prepareAiClipping(jsonObject: JSONObject): AiClipping?{
        val aiClipping = jsonObject.optJSONObject("aiClipping")?.let { aiClippingJson ->
            return AiClipping(
                audioDataUrl = aiClippingJson.optString("audioDataUrl", null),
                audioTracksUrl = aiClippingJson.optString("audioTracksUrl", null)
            )
        }
        return null;
    }

    private fun prepareAiCaptions(jsonObject: JSONObject): AiCaptions?{
        val aiCaptions = jsonObject.optJSONObject("aiCaptions")?.let { aiCaptionsJson ->
            return AiCaptions(
                uploadUrl = aiCaptionsJson.optString("uploadUrl", null),
                transcribeUrl = aiCaptionsJson.optString("transcribeUrl", null),
                apiKey = aiCaptionsJson.optString("apiKey", null)
            )
        }
        return null
    }

    private fun prepareAudioBrowser(jsonObject: JSONObject): AudioBrowser?{
        val audioBrowser = jsonObject.optJSONObject("audioBrowser")?.let { audioBrowserJson ->
            val paramsObject = audioBrowserJson.optJSONObject("params")
            return AudioBrowser(
                source = audioBrowserJson.optString("source", null),
                params = paramsObject
            )
        }
        return null
    }

    private fun createExtras(androidConfig: AndroidConfig?): Bundle? {
        return androidConfig?.aiCaptions?.let {
            bundleOf(
                CaptionsApiService.ARG_CAPTIONS_UPLOAD_URL to it.uploadUrl,
                CaptionsApiService.ARG_CAPTIONS_TRANSCRIBE_URL to it.transcribeUrl,
                CaptionsApiService.ARG_API_KEY to it.apiKey
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        currentActivity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        currentActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        currentActivity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        currentActivity = null
    }
}
