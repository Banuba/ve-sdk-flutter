package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import androidx.core.os.bundleOf
import android.os.Bundle
import android.util.Log
import org.json.JSONException
import org.json.JSONObject
import com.banuba.sdk.veui.data.captions.CaptionsApiService


private val emptyFeaturesConfig = FeaturesConfig(aiClipping = null, aiCaptions = null, AudioBrowser(source = "local", params = null))

private fun JSONObject.extractAiClipping(): AiClipping?{
    return try {
        this.optJSONObject("aiClipping")?.let { aiClipping ->
            AiClipping(
                audioDataUrl = aiClipping.optString("audioDataUrl"),
                audioTracksUrl = aiClipping.optString("audioDataUrl")
            )
        }
    } catch (e: JSONException){
        Log.d(TAG, "Missing AiClipping params", e)
        null
    }
}

private fun JSONObject.extractAiCaptions(): AiCaptions?{
    return try {
        this.optJSONObject("aiCaptions")?.let { aiCaptions ->
            AiCaptions(
                uploadUrl = aiCaptions.optString("uploadUrl"),
                transcribeUrl = aiCaptions.optString("transcribeUrl"),
                apiKey = aiCaptions.optString("apiKey")
            )
        }
    } catch (e: JSONException){
        Log.d(TAG, "Missing AiCaptions params", e)
        null
    }
}

private fun JSONObject.extractAudioBrowser(): AudioBrowser{
    val defaultAudioBrowser = emptyFeaturesConfig.audioBrowser
    return try {
        val audioBrowserObject = this.optJSONObject("audioBrowser") ?: return defaultAudioBrowser
        Log.d(TAG, "${audioBrowserObject}")
        AudioBrowser(
            source = audioBrowserObject.optString("source"),
            params = audioBrowserObject.optJSONObject("params")
        )
    } catch (e: JSONException){
        Log.d(TAG, "Missing Audio Browser params", e)
        defaultAudioBrowser
    }
}

internal fun parseFeaturesConfig(rawConfigParams: String?): FeaturesConfig {
    return try {
        rawConfigParams?.let {
            val featuresConfigObject = JSONObject(it)
            FeaturesConfig(
                featuresConfigObject.extractAiClipping(),
                featuresConfigObject.extractAiCaptions(),
                featuresConfigObject.extractAudioBrowser()
            )
        } ?: emptyFeaturesConfig
    } catch (e: JSONException) {
        Log.d(TAG, "Missing or invalid config params, will use default config", e)
        emptyFeaturesConfig
    }
}

internal fun createExtras(aiCaptions: AiCaptions?): Bundle {
    aiCaptions?.let { aiCaptions ->
        return bundleOf(
            CaptionsApiService.ARG_CAPTIONS_UPLOAD_URL to aiCaptions.uploadUrl,
            CaptionsApiService.ARG_CAPTIONS_TRANSCRIBE_URL to aiCaptions.transcribeUrl,
            CaptionsApiService.ARG_API_KEY to aiCaptions.apiKey
        )
    } ?: run {
        return Bundle()
    }

}

