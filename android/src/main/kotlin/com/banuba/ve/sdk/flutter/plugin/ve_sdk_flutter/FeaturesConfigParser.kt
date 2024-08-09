package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.util.Log
import org.json.JSONException
import org.json.JSONObject

internal fun parseFeaturesConfig(rawConfigParams: String?): FeaturesConfig {
    rawConfigParams?.let { params ->
        return try {
            val featuresConfigObject = JSONObject(params)
            FeaturesConfig(
                featuresConfigObject.extractAiClipping(),
                featuresConfigObject.extractAiCaptions(),
                featuresConfigObject.extractAudioBrowser(),
                featuresConfigObject.extractEditorConfig(),
                featuresConfigObject.extractDraftConfig()
            )
        } catch (e: JSONException) {
            emptyFeaturesConfig
        }
    } ?: return emptyFeaturesConfig
}

private fun JSONObject.extractAiClipping(): AiClipping? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_AI_CLIPPING)?.let { json ->
            AiClipping(
                audioDataUrl = json.optString(FEATURES_CONFIG_AI_CLIPPING_AUDIO_DATA_URL),
                audioTracksUrl = json.optString(FEATURES_CONFIG_AI_CLIPPING_AUDIO_TRACK_URL)
            )
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing AiClipping params", e)
        null
    }
}

private fun JSONObject.extractAiCaptions(): AiCaptions? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_AI_CAPTIONS)?.let { json ->
            AiCaptions(
                uploadUrl = json.optString(FEATURES_CONFIG_AI_CAPTIONS_UPLOAD_URL),
                transcribeUrl = json.optString(FEATURES_CONFIG_AI_CAPTIONS_TRANSCRIBE_URL),
                apiKey = json.optString(FEATURES_CONFIG_AI_CAPTIONS_API_KEY)
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
        this.optJSONObject(FEATURES_CONFIG_AUDIO_BROWSER)?.let { json ->
            AudioBrowser(
                source = json.optString(FEATURES_CONFIG_AUDIO_BROWSER_SOURCE),
                params = json.optJSONObject(FEATURES_CONFIG_AUDIO_BROWSER_PARAMS)
            )
        } ?: run {
            defaultAudioBrowser
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Audio Browser params", e)
        defaultAudioBrowser
    }
}

private fun JSONObject.extractEditorConfig(): EditorConfig? {
    return try {
        this.optJSONObject(FEATURES_CONFIG_EDITOR_CONFIG)?.let { json ->
            EditorConfig(
                // The EditorConfig may come without "isVideoAspectFillEnabled" parameter (null)
                // from the Flutter side.
                // If isVideoAspectFillEnabled" is null, the default value is set to true.
                // Because this parameter is set to true by default in IOS.
                isVideoAspectFillEnabled = json.optBoolean(
                    FEATURES_CONFIG_EDITOR_CONFIG_VIDEO_ASPECT_ENABLED, true
                )
            )
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Editor Config params", e)
        null
    }
}

private fun JSONObject.extractDraftConfig(): DraftConfig {
    val defaultDraftConfig = emptyFeaturesConfig.draftConfig
    return try {
        this.optJSONObject(FEATURES_CONFIG_DRAFT_CONFIG)?.let { json ->
            DraftConfig(
                option = json.optString(FEATURES_CONFIG_DRAFT_CONFIG_OPTION),
            )
        } ?: run {
            defaultDraftConfig
        }
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Draft Config params", e)
        defaultDraftConfig
    }
}