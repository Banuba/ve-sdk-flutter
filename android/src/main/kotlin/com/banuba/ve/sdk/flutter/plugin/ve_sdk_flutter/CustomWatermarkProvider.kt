package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.util.Log
import com.banuba.sdk.ve.effects.watermark.WatermarkProvider
import com.banuba.sdk.utils.ContextProvider.getAssets

class CustomWatermarkProvider(private val context: Context, private val imagePath: String) : WatermarkProvider {

    override fun getWatermarkBitmap(): Bitmap? {
        return try {
            val inputStream = context.assets.open("flutter_assets/" + imagePath)
            val watermark = BitmapFactory.decodeStream(inputStream)
            inputStream.close()
            watermark
        } catch (e: Exception) {
            Log.w(TAG, "Error opening asset: ${e.message}")
            null
        }
    }
}