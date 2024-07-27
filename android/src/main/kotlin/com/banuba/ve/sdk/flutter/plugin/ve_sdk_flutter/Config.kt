package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

internal data class AndroidConfig(

    val aiClipping: AiClipping? = null,
    val aiCaptions: AiCaptions? = null
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