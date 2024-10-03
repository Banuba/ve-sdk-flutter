package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.util.Log
import org.json.JSONException
import org.json.JSONObject
import org.json.JSONArray

internal fun parseExportParam(rawExportParam: String?): ExportParam? =
    if (rawExportParam.isNullOrEmpty()) {
        null
    } else {
        try {
            val exportParamObject = JSONObject(rawExportParam)
            ExportParam(
                exportParamObject.extractExportedVideos(),
                exportParamObject.extractWatermark()
            )
        } catch (e: JSONException) {
            Log.d(TAG, "Missing Export Param", e)
            null
        }
    }

internal fun JSONObject.extractExportedVideos(): List<ExportedVideo> {
    return try {
        val jsonArray = this.getJSONArray(EXPORT_PARAM_EXPORTED_VIDEOS)
        val exportedVideos = mutableListOf<ExportedVideo>()

        for (i in 0 until jsonArray.length()) {
            val exportConfigObject = jsonArray.getJSONObject(i)

            val exportedVideo = ExportedVideo(
                fileName = exportConfigObject.optString(
                    EXPORTED_VIDEOS_FILE_NAME,
                    EXPORTED_VIDEOS_FILE_NAME_DEFAULT
                ),
                videoResolution = exportConfigObject.optString(
                    EXPORTED_VIDEOS_VIDEO_RESOLUTION,
                    EXPORTED_VIDEOS_VIDEO_RESOLUTION_AUTO
                ),
                useHevcIfPossible = exportConfigObject.optBoolean(EXPORTED_VIDEOS_HEVC_CODEC, true)
            )

            exportedVideos.add(exportedVideo)
        }
        exportedVideos
    } catch (e: JSONException) {
        Log.d(TAG, "Missing Exported Video params", e)
        defaultExportParam.exportedVideos
    }
}

private fun JSONObject.extractWatermark(): Watermark? {
    return try {
        this.optJSONObject(EXPORT_PARAMS_WATERMARK)?.let { json ->
            Watermark(
                imagePath = json.optString(EXPORT_PARAMS_WATERMARK_IMAGE_PATH),
                watermarkAlignment = json.optString(EXPORT_PARAMS_WATERMARK_ALIGNMENT)
            )
        } ?: null
    } catch (e: JSONException) {
        Log.w(TAG, "Missing Watermark params", e)
        null
    }
}