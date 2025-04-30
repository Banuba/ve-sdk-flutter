# Editor screen

## Usage

Specify instance of ```EditorConfig``` in ```FeaturesConfig``` builder:

```dart
final config = FeaturesConfigBuilder()
      .setEditorConfig(
          EditorConfig(
              enableVideoAspectFill: false,
              supportsColorEffects: false,
              supportsVisualEffects: false
          )
      )
      ...
      .build()
```

### Options

- ```enableVideoAspectFill``` - Fill video aspect on the editor screen while playback. Default value is ```true```.
- ```supportsColorEffects``` - Determines whether the editor supports color effects. Default value is ```true```.
- ```supportsVisualEffects ```- Determines whether the editor supports visual effects. Default value is ```true```.
  