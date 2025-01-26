# Video Duration

```VideoDurationConfig``` is responsible for customizing video recording durations.

## Usage

Specify instance of ```VideoDurationConfig``` in ```FeaturesConfig```:

```dart
    final config = FeaturesConfigBuilder()
    .setVideoDurationConfig(VideoDurationConfig(
        maxTotalVideoDuration: 180.0, 
        videoDurations: [180.0, 120.0, 60.0]
    ))
    ...
    .build()
```
