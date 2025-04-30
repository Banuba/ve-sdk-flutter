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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
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

        // Example of enabling Editor V2 and Video Duration config

        .enableEditorV2(true)
        .setVideoDurationConfig(VideoDurationConfig(maxTotalVideoDuration: 180.0, videoDurations: [180.0, 120.0, 60.0, 30.0]))
        .setAudioBrowser(AudioBrowser.fromSource(AudioBrowserSource.disabled))
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
        backgroundColor: Colors.black38,
        centerTitle: true,
        title: const Text("Video Editor Flutter plugin"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'The plugin demonstrates how to use Banuba Video Editor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Visibility(
                    visible: _errorMessage.isNotEmpty,
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17.0, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      fixedSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _startVideoEditorInCameraMode(),
                    child: const Text(
                      'Open Video Editor - Camera screen',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      fixedSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _startVideoEditorInPipMode(),
                    child: const Text(
                      'Open Video Editor - PIP screen ',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      fixedSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _startVideoEditorInTrimmerMode(),
                    child: const Text(
                      'Open Video Editor - Trimmer screen',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

