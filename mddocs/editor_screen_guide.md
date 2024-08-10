# Editor screen

## Usage

Specify instance of ```EditorConfig``` in ```FeaturesConfig``` builder:

```dart
final config = FeaturesConfigBuilder()
      .setEditorConfig(EditorConfig(isVideoAspectFillEnabled: false))
      ...
      .build()
```

### Configurations

- isVideoAspectFillEnabled - Fill video aspect on the editor screen while playback. Default value is ```true```.