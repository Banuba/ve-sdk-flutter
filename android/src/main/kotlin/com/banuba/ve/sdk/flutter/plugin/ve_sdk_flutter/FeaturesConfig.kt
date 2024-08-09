package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import org.json.JSONObject

internal data class FeaturesConfig(
    val aiClipping: AiClipping?,
    val aiCaptions: AiCaptions?,
    val audioBrowser: AudioBrowser,
    val editorConfig: EditorConfig?,
    val draftConfig: DraftConfig
)

internal data class AiClipping(
    val audioDataUrl: String,
    val audioTracksUrl: String
)

internal data class AiCaptions(
    val uploadUrl: String,
    val transcribeUrl: String,
    val apiKey: String
)

internal data class AudioBrowser(
    val source: String,
    val params: JSONObject?
)

internal data class EditorConfig(
    val isVideoAspectFillEnabled: Boolean?
)

internal data class DraftConfig(
    val option: String
)