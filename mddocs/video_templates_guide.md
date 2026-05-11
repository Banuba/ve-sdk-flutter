# Video Templates

Templates let users create stunning videos quickly and easily using predefined sets of effects, transitions, and music. 
All it takes to make a shareable piece is changing the placeholders. With templates, even people who are new to video editing or just lack time can make impressive content in minutes.

> [!NOTE]
> The ```Video Templates``` is not enabled by default. Contact Banuba representatives to know more.

## Launch Video Templates

```dart
Future<void> _startVideoEditorInCameraMode() async {
    // Specify your Config params in the builder below

    final config = FeaturesConfigBuilder()
      ...
      .build();
    
    try {
      dynamic exportResult = await _veSdkFlutterPlugin
          .openTemplatesScreen(_licenseToken, config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }
```

## Setup Custom Templates

```dart
    final config = FeaturesConfigBuilder()
      .setTemplatesConfig(TemplatesConfig(url: "YOUR_URL"))
      ...
      .build();
```

## Templates Builder 

To launch Templates Builder, set `enableTemplatesBuilder` to `true` and provide a `termsOfUse` link in `TemplatesConfig`, then pass this configuration to `_veSdkFlutterPlugin.openTemplatesScreen`:

```dart

  final config = FeaturesConfigBuilder()
    .setTemplatesConfig(TemplatesConfig(
        enableTemplatesBuilder: true,
        termsOfUse: "LINK TO YOUR TERMS OF USE"
    ))
    .build();
```