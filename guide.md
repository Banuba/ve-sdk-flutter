# Integration Guide

## Add AR effects
[Banuba Face AR SDK](https://www.banuba.com/facear-sdk/face-filters) product is used on camera and editor screens for applying various AR effects while making video content.

:exclamation: IMPORTANT
Please add beautification effect to your project. 

1. Android - copy [Beauty](example/android/app/src/main/assets/bnb-resources/effects/Beauty) effect and paste it to ```assets/bnb-resources/effects``` in your project.
1. iOS - add effects to resource folder ```bundleEffects```

## Limit processor architectures on Android
Banuba Video Editor on Android supports the following processor architectures - ```arm64-v8a```, ```armeabi-v7a```, ```x86-64```.
Please keep in mind that each architecture adds extra MBs to your app.
To reduce the app size you can filter architectures in your ```app/build.gradle file```.

```groovy
...
defaultConfig {
    ...
    // Use only ARM processors
    ndk {
        abiFilters 'armeabi-v7a', 'arm64-v8a'
    }
}
```