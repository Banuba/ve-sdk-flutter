package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter
import org.json.JSONObject

internal data class AndroidConfig(
    val aiClipping: AiClipping?,
    val aiCaptions: AiCaptions?,
    val audioBrowser: AudioBrowser?
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
    val params: JSONObject?,
)