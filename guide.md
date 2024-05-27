# Integration Guide

## Supported processor architectures on Android
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

## Add AR effects
[Banuba Face AR SDK](https://www.banuba.com/facear-sdk/face-filters) product is used on camera and editor screens for applying various AR effects while making video content.

There are 2 options for managing AR effects:
1. Store effects in the app
   2. Android - add effects to folder ```assets/bnb-resources/effects```
   3. iOS - add effects to resource folder ```bundleEffects```
2. Use [AR Cloud](https://www.banuba.com/faq/what-is-ar-cloud) for storing effects on a server.