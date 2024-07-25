package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

data class Config(
    val autoCut: AutoCut? = null,
    val closeCaptions: CloseCaptions? = null
)

data class AutoCut(
    val audioDataUrl: String,
    val audioTracksUrl: String
)

data class CloseCaptions(
    val argCaprionsUploadUrl: String,
    val argCaptionsTranscribeUrl: String,
    val argApiKey: String
)