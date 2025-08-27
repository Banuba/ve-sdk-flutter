# Cover Screen

Cover image screen allows users to pick any frame of video as image or choose an image from gallery.

## Usage

Specify instance of ```ConfigConfig``` in ```FeaturesConfigBuilder``` builder:

```dart
    final config = FeaturesConfigBuilder()
        .setCoverConfig(CoverConfig(
            supportsCoverScreen: false
        ))
        .build();
```

### Options

- ```supportsCoverScreen``` - Determines whether the Cover screen supports. Default value is ```true```.
