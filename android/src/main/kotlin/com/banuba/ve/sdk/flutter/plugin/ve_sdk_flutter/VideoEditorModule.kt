package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.app.Application
import androidx.fragment.app.Fragment
import com.banuba.sdk.arcloud.data.source.ArEffectsRepositoryProvider
import com.banuba.sdk.arcloud.di.ArCloudKoinModule
import com.banuba.sdk.audiobrowser.di.AudioBrowserKoinModule
import com.banuba.sdk.audiobrowser.domain.AudioBrowserMusicProvider
import com.banuba.sdk.core.data.TrackData
import com.banuba.sdk.core.ui.ContentFeatureProvider
import com.banuba.sdk.effectplayer.adapter.BanubaEffectPlayerKoinModule
import com.banuba.sdk.export.di.VeExportKoinModule
import com.banuba.sdk.gallery.di.GalleryKoinModule
import com.banuba.sdk.playback.di.VePlaybackSdkKoinModule
import com.banuba.sdk.ve.di.VeSdkKoinModule
import com.banuba.sdk.ve.flow.di.VeFlowKoinModule
import com.banuba.sdk.veui.di.VeUiSdkKoinModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.core.qualifier.named
import org.koin.dsl.module
import com.banuba.sdk.audiobrowser.autocut.AutoCutTrackLoaderSoundstripe
import com.banuba.sdk.core.data.autocut.AutoCutTrackLoader
import com.banuba.sdk.ve.data.autocut.AutoCutConfig
import com.banuba.sdk.audiobrowser.domain.SoundstripeProvider
import com.banuba.sdk.audiobrowser.data.MubertApiConfig
import org.json.JSONObject
import org.json.JSONException
import org.koin.core.module.Module
import android.util.Log

class VideoEditorModule {
    internal fun initialize(application: Application, androidConfigObject: JSONObject?) {
        startKoin {
            androidContext(application)
            allowOverride(true)

            // IMPORTANT! order of modules is required
            modules(
                VeSdkKoinModule().module,
                VeExportKoinModule().module,
                VePlaybackSdkKoinModule().module,

                AudioBrowserKoinModule().module,

                // IMPORTANT! ArCloudKoinModule should be set before TokenStorageKoinModule to get effects from the cloud
                ArCloudKoinModule().module,

                VeUiSdkKoinModule().module,
                VeFlowKoinModule().module,
                BanubaEffectPlayerKoinModule().module,
                GalleryKoinModule().module,

                // Sample integration module
                SampleIntegrationVeKoinModule(androidConfigObject).module,
            )
        }
    }
}

/**
 * All dependencies mentioned in this module will override default
 * implementations provided in VE UI SDK.
 * Some dependencies has no default implementations. It means that
 * these classes fully depends on your requirements
 */
private class SampleIntegrationVeKoinModule(androidConfigObject: JSONObject?) {

    val module = module {
        single<ArEffectsRepositoryProvider>(createdAtStart = true) {
            ArEffectsRepositoryProvider(
                arEffectsRepository = get(named("backendArEffectsRepository")),
                ioDispatcher = get(named("ioDispatcher"))
            )
        }

        androidConfigObject?.let { androidConfigObject ->
            addAiClipping(this, androidConfigObject)
            addAudioBrowser(this, androidConfigObject)
        } ?: run {
            registerDefaultMusicTrackProvider(this)
        }
    }

    private fun addAiClipping(module: Module, androidConfigObject: JSONObject){
        try {
            androidConfigObject.optJSONObject("aiClipping")?.let { aiClipping ->
                module.single<AutoCutConfig> {
                    AutoCutConfig(
                        audioDataUrl = aiClipping.optString("audioDataUrl"),
                        audioTracksUrl = aiClipping.optString("audioDataUrl")
                    )
                }
                module.single<AutoCutTrackLoader> {
                    AutoCutTrackLoaderSoundstripe(
                        soundstripeApi = get()
                    )
                }
            }
        } catch (e: JSONException){
            Log.d("TAG", "Error processing aiClipping", e)
        }
    }

    private fun addAudioBrowser(module: Module, androidConfigObject: JSONObject){
        try {
            androidConfigObject.optJSONObject("audioBrowser")?.let { audioBrowser ->
                val source = audioBrowser.optString("source")
                val paramsObject = audioBrowser.optJSONObject("params")

                module.single<ContentFeatureProvider<TrackData, Fragment>>(
                    named("musicTrackProvider")
                ) {
                    when (source) {
                        "soundstripe" -> SoundstripeProvider()
                        "local" -> AudioBrowserMusicProvider()
                        else -> { AudioBrowserMusicProvider() }
                    }
                }
                audioBrowser.optJSONObject("params")?.let { paramsObject ->
                    parseAudioBrowserParams(module, paramsObject)
                }
            } ?: run {
                registerDefaultMusicTrackProvider(module)
            }
        } catch (e: JSONException){
            Log.d(TAG, "Error processing AudioBrowser", e)
        }
    }

    private fun registerDefaultMusicTrackProvider(module: Module) {
        module.single<ContentFeatureProvider<TrackData, Fragment>>(
            named("musicTrackProvider")
        ) {
            AudioBrowserMusicProvider()
        }
    }

    private fun parseAudioBrowserParams(module: Module, paramsObject: JSONObject){
        val paramsMap = paramsObject.keys().asSequence().associateWith { key ->
            paramsObject.get(key)
        }

        val mubertLicence = paramsMap["mubertLicence"] as? kotlin.String
        val mubertToken = paramsMap["mubertToken"] as? kotlin.String

        if (mubertLicence != null && mubertToken != null) {
            module.single {
                MubertApiConfig(
                    mubertLicence = mubertLicence,
                    mubertToken = mubertToken
                )
            }
        } else {
            Log.d(TAG, "Missing parameters mubertLicence and mubertToken")
        }
    }
}