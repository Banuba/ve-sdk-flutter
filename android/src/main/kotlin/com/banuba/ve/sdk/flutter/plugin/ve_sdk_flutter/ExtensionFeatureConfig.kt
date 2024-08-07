package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.util.Log
import org.json.JSONException
import org.json.JSONObject

internal fun parseFeaturesConfig(rawConfigParams: String?): FeaturesConfig {
    rawConfigParams?.let {
        return try {
            val featuresConfigObject = JSONObject(it)
            FeaturesConfig(
                featuresConfigObject.extractAiClipping(),
                featuresConfigObject.extractAiCaptions(),
                featuresConfigObject.extractAudioBrowser(),
                featuresConfigObject.extractEditorConfig(),
            )
        } catch (e: JSONException) {
            emptyFeaturesConfig
        }
    } ?: return emptyFeaturesConfig
}

private fun JSONObject.extractAiClipping(): AiClipping? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_AI_CLIPPING)?.let { aiClipping ->
            AiClipping(
                audioDataUrl = aiClipping.optString(FEATURES_CONFIG_AI_CLIPPING_AUDIO_DATA_URL),
                audioTracksUrl = aiClipping.optString(FEATURES_CONFIG_AI_CLIPPING_AUDIO_TRACK_URL)
            )
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing AiClipping params", e)
        null
    }
}

private fun JSONObject.extractAiCaptions(): AiCaptions? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_AI_CAPTIONS)?.let { aiCaptions ->
            AiCaptions(
                uploadUrl = aiCaptions.optString(FEATURES_CONFIG_AI_CAPTIONS_UPLOAD_URL),
                transcribeUrl = aiCaptions.optString(FEATURES_CONFIG_AI_CAPTIONS_TRANSCRIBE_URL),
                apiKey = aiCaptions.optString(FEATURES_CONFIG_AI_CAPTIONS_API_KEY)
            )
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing AiCaptions params", e)
        null
    }
}

private fun JSONObject.extractAudioBrowser(): AudioBrowser {
    val defaultAudioBrowser = emptyFeaturesConfig.audioBrowser
    return try {
        val audioBrowserObject =
            this.optJSONObject(FEATURES_CONFIG_AUDIO_BROWSER) ?: return defaultAudioBrowser
        AudioBrowser(
            source = audioBrowserObject.optString(FEATURES_CONFIG_AUDIO_BROWSER_SOURCE),
            params = audioBrowserObject.optJSONObject(FEATURES_CONFIG_AUDIO_BROWSER_PARAMS)
        )
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Audio Browser params", e)
        defaultAudioBrowser
    }
}

private fun JSONObject.extractEditorConfig(): EditorConfig? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_EDITOR_CONFIG)?.let { editorConfig ->
            EditorConfig(
                isVideoAspectFillEnabled = editorConfig.optBoolean(
                    FEATURES_CONFIG_EDITOR_CONFIG_VIDEO_ASPECT_ENABLED, true
                )
            )
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Editor Config params", e)
        null
    }
}