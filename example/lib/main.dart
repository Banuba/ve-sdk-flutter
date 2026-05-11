import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ve_sdk_flutter/export_data.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

const _licenseToken = SET UP YOUR LICENSE TOKEN;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _veSdkFlutterPlugin = VeSdkFlutter();
  String _errorMessage = '';

  Future<void> _startVideoEditorInCameraMode() async {
    // Specify your Config params in the builder below

    final config = FeaturesConfigBuilder()
        // .setCaptions(...)
        // ...
        .build();

    // Export data example

    // const exportData = ExportData(exportedVideos: [
    //   ExportedVideo(
    //       fileName: "export_HD",
    //       videoResolution: VideoResolution.hd720p
    //   )],
    //     watermark: Watermark(
    //        imagePath: "assets/watermark.png",
    //        alignment: WatermarkAlignment.topLeft
    //     )
    // );

    try {
      dynamic exportResult = await _veSdkFlutterPlugin
          .openCameraScreen(_licenseToken, config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  Future<void> _startVideoEditorInTemplatesMode() async {

    final config = FeaturesConfigBuilder()
    // .setTemplatesConfig
    // ...
       .build();

    try {
      dynamic exportResult = await _veSdkFlutterPlugin.openTemplatesScreen(_licenseToken, config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  Future<void> _startVideoEditorInTemplatesBuilderMode() async {

    final config = FeaturesConfigBuilder()
        .setTemplatesConfig(TemplatesConfig(
          enableBuilder: true,
          termsOfUseURL: "https://www.banuba.com/terms"
        ))
    // ...
        .build();

    try {
      dynamic exportResult = await _veSdkFlutterPlugin.openTemplatesScreen(_licenseToken, config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  Future<void> _startVideoEditorInPipMode() async {

    // Specify your Config params in the builder below

    final config = FeaturesConfigBuilder()
      // .setAudioBrowser(...)
      // ...
      .build();
    final ImagePicker picker = ImagePicker();
    final videoFile = await picker.pickVideo(source: ImageSource.gallery);

    final sourceVideoFile = videoFile?.path;
    if (sourceVideoFile == null) {
      debugPrint('Error: Cannot start video editor in pip mode: please pick video file');
      return;
    }

    try {
      dynamic exportResult = await _veSdkFlutterPlugin.openPipScreen(
          _licenseToken, config, sourceVideoFile);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  Future<void> _startVideoEditorInTrimmerMode() async {

    // Specify your Config params in the builder below

    final config = FeaturesConfigBuilder()
      // .setDraftConfig(...)
      //...
      .build();
    final ImagePicker picker = ImagePicker();
    final videoFiles = await picker.pickMultipleMedia(imageQuality: 3);

    if (videoFiles.isEmpty) {
      debugPrint('Error: Cannot start video editor in trimmer mode: please pick video files');
      return;
    }

    final sources = videoFiles.map((f) => f.path).toList();

    try {
      dynamic exportResult = await _veSdkFlutterPlugin.openTrimmerScreen(
          _licenseToken, config, sources);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(ExportResult? result) {
    if (result == null) {
      debugPrint('No export result! The user has closed video editor before export');
      return;
    }

    // The list of exported video file paths
    debugPrint('Exported video files = ${result.videoSources}');

    // Preview as a image file taken by the user. Null - when preview screen is disabled.
    debugPrint('Exported preview file = ${result.previewFilePath}');

    // Meta file where you can find short data used in exported video
    debugPrint('Exported meta file = ${result.metaFilePath}');
  }

  void _handlePlatformException(PlatformException exception) {
    _errorMessage = exception.message ?? 'unknown error';
    // You can find error codes 'package:ve_sdk_flutter/errors.dart';
    debugPrint("Error: code = ${exception.code}, message = $_errorMessage");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
            "Video Editor Flutter plugin",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Visibility(
              visible: _errorMessage.isNotEmpty,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17.0, color: Colors.red),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      CustomButton(title: 'Open Video Editor - Default', onPressed: _startVideoEditorInCameraMode),
                      CustomButton(title: 'Open Video Editor - Templates', onPressed: _startVideoEditorInTemplatesMode),
                      CustomButton(title: 'Open Video Editor - Templates Builder', onPressed: _startVideoEditorInTemplatesBuilderMode),
                      CustomButton(title: 'Open Video Editor - PIP', onPressed: _startVideoEditorInPipMode),
                      CustomButton(title: 'Open Video Editor - Trimmer', onPressed: _startVideoEditorInTrimmerMode),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shadowColor: Colors.blueGrey,
        elevation: 10,
        fixedSize: const Size(300, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.0,
        ),
      ),
    );
  }
}

