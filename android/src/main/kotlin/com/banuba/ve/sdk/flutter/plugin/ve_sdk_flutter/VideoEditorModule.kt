package com.banuba.ve.sdk.flutter.plugin.ve_sdk_flutter

import android.app.Application
import androidx.fragment.app.Fragment
import com.banuba.sdk.arcloud.data.source.ArEffectsRepositoryProvider
import com.banuba.sdk.arcloud.di.ArCloudKoinModule
import com.banuba.sdk.audiobrowser.di.AudioBrowserKoinModule
import com.banuba.sdk.audiobrowser.domain.AudioBrowserMusicProvider
import com.banuba.sdk.core.data.TrackData
import com.banuba.sdk.core.ui.ContentFeatureProvider
import com.banuba.sdk.effectplayer.adapter.BanubaEffectPlayerKoinModule
import com.banuba.sdk.export.di.VeExportKoinModule
import com.banuba.sdk.gallery.di.GalleryKoinModule
import com.banuba.sdk.playback.di.VePlaybackSdkKoinModule
import com.banuba.sdk.ve.di.VeSdkKoinModule
import com.banuba.sdk.ve.flow.di.VeFlowKoinModule
import com.banuba.sdk.veui.di.VeUiSdkKoinModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.core.qualifier.named
import org.koin.dsl.module
import com.banuba.sdk.audiobrowser.autocut.AutoCutTrackLoaderSoundstripe
import com.banuba.sdk.core.data.autocut.AutoCutTrackLoader
import com.banuba.sdk.ve.data.autocut.AutoCutConfig
import com.banuba.sdk.audiobrowser.domain.SoundstripeProvider
import com.banuba.sdk.audiobrowser.data.MubertApiConfig
import android.util.Log

class VideoEditorModule {
    internal fun initialize(application: Application, androidConfig: AndroidConfig?) {
        startKoin {
            androidContext(application)
            allowOverride(true)

            // IMPORTANT! order of modules is required
            modules(
                VeSdkKoinModule().module,
                VeExportKoinModule().module,
                VePlaybackSdkKoinModule().module,

                AudioBrowserKoinModule().module,

                // IMPORTANT! ArCloudKoinModule should be set before TokenStorageKoinModule to get effects from the cloud
                ArCloudKoinModule().module,

                VeUiSdkKoinModule().module,
                VeFlowKoinModule().module,
                BanubaEffectPlayerKoinModule().module,
                GalleryKoinModule().module,

                // Sample integration module
                SampleIntegrationVeKoinModule(androidConfig).module,
            )
        }
    }
}

/**
 * All dependencies mentioned in this module will override default
 * implementations provided in VE UI SDK.
 * Some dependencies has no default implementations. It means that
 * these classes fully depends on your requirements
 */
private class SampleIntegrationVeKoinModule(androidConfig: AndroidConfig?) {

    val module = module {
        single<ArEffectsRepositoryProvider>(createdAtStart = true) {
            ArEffectsRepositoryProvider(
                arEffectsRepository = get(named("backendArEffectsRepository")),
                ioDispatcher = get(named("ioDispatcher"))
            )
        }

        single<ContentFeatureProvider<TrackData, Fragment>>(
            named("musicTrackProvider")
        ) {
            if (androidConfig?.audioBrowser?.source != null){
                val source = androidConfig.audioBrowser.source
                when (source) {
                    "soundStripe" -> SoundstripeProvider()
                    "local" -> AudioBrowserMusicProvider()
                    else -> { AudioBrowserMusicProvider() }
                }
            } else {
                AudioBrowserMusicProvider()
            }
        }

        androidConfig?.audioBrowser?.params?.let { params ->
            val paramsMap = params.keys().asSequence().associateWith { key ->
                params.get(key)
            }
            val mubertLicence = paramsMap["mubertLicence"] as? String
            val mubertToken = paramsMap["mubertToken"] as? String

            if (mubertLicence != null && mubertToken != null) {
                single {
                    MubertApiConfig(
                        mubertLicence = mubertLicence,
                        mubertToken = mubertToken
                    )
                }
            } else {
                Log.d(TAG, "Missing parameters mubertLicence and mubertToken")
            }
        }

        androidConfig?.aiClipping?.let { aiClipping ->
            single<AutoCutConfig> {
                AutoCutConfig(
                    audioDataUrl = aiClipping.audioDataUrl,
                    audioTracksUrl = aiClipping.audioTracksUrl
                )
            }
            single<AutoCutTrackLoader> {
                AutoCutTrackLoaderSoundstripe(
                    soundstripeApi = get()
                )
            }
        }
    }
}