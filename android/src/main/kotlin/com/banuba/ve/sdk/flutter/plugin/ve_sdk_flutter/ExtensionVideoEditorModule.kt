package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import org.koin.core.module.Module
import androidx.fragment.app.Fragment
import com.banuba.sdk.core.data.TrackData
import com.banuba.sdk.core.ui.ContentFeatureProvider
import com.banuba.sdk.audiobrowser.domain.AudioBrowserMusicProvider
import com.banuba.sdk.audiobrowser.data.MubertApiConfig
import com.banuba.sdk.audiobrowser.autocut.AutoCutTrackLoaderSoundstripe
import com.banuba.sdk.core.data.autocut.AutoCutTrackLoader
import com.banuba.sdk.ve.data.autocut.AutoCutConfig
import com.banuba.sdk.audiobrowser.domain.SoundstripeProvider
import org.json.JSONException
import org.json.JSONObject
import org.koin.core.qualifier.named
import android.util.Log


internal fun AudioBrowser.addAudioBrowser(module: Module){

    val source = this.source

    module.single<ContentFeatureProvider<TrackData, Fragment>>(
        named("musicTrackProvider")
    ) {
        when (source) {
            "soundstripe" -> SoundstripeProvider()
            "local" -> AudioBrowserMusicProvider()
            else -> { AudioBrowserMusicProvider() }
        }
    }

    updateAudioBrowserWithParams(module, this.params)
}

private fun updateAudioBrowserWithParams(module: Module, paramsObject: JSONObject?){
    paramsObject?.let {
        try {
            val paramsMap = paramsObject.keys().asSequence().associateWith { key ->
                paramsObject.get(key)
            }

            val mubertLicence = paramsMap["mubertLicence"] as? String
            val mubertToken = paramsMap["mubertToken"] as? String

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
        } catch (e: JSONException){
            Log.d(TAG, "Error parsing Params of AudioBrowser")
        }
    } ?: run {
        Log.d(TAG, "Missing Params of AudioBrowser")
        return
    }
}

internal fun AiClipping.addAiClipping(module: Module){
    this?.let { aiClipping ->
        module.single<AutoCutConfig> {
            AutoCutConfig(
                audioDataUrl = aiClipping.audioDataUrl,
                audioTracksUrl = aiClipping.audioTracksUrl
            )
        }
        module.single<AutoCutTrackLoader> {
            AutoCutTrackLoaderSoundstripe(
                soundstripeApi = get()
            )
        }
    }
}