# Camera screen

## Usage

Specify instance of ```CameraConfig``` in ```FeaturesConfig``` builder:

```dart
final config = FeaturesConfigBuilder()
      .setCameraConfig(
          CameraConfig(
              supportsBeauty: false,
              supportsColorEffects: false,
              supportsMasks: false
          )
      )
      ...
      .build()
```

### Options

- ```supportsBeauty``` - Determines whether the camera supports beauty effect. Default value is ```true```.
- ```supportsColorEffects``` - Determines whether the camera supports color effects. Default value is ```true```.
- ```supportsMasks``` - Determines whether the camera supports visual effects. Default value is ```true```.