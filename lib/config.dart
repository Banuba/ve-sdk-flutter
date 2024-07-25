import 'dart:convert';

import 'package:flutter/material.dart';

class Config{

  AutoCut? autoCut;
  CloseCaptions? closeCaptions;

  Config({this.autoCut, this.closeCaptions});

  void setAutoCut({required String audioDataUrl, required String audioTracksUrl}){
    autoCut = AutoCut(audioDataUrl: audioDataUrl, audioTracksUrl: audioTracksUrl);
  }

  void setCloseCaptions({required String argCaprionsUploadUrl, required String argCaptionsTranscribeUrl, required String argApiKey}){
    closeCaptions = CloseCaptions(argCaprionsUploadUrl: argCaprionsUploadUrl, argCaptionsTranscribeUrl: argCaptionsTranscribeUrl, argApiKey: argApiKey);
  }

  String serializeToJson() {
    final Map<String, dynamic> configMap = {
      'autoCut': autoCut != null ? {
        'audioDataUrl': autoCut!.audioDataUrl,
        'audioTracksUrl': autoCut!.audioTracksUrl,
      } : null,
      'closeCaptions': closeCaptions != null ? {
        'argCaprionsUploadUrl': closeCaptions!.argCaprionsUploadUrl,
        'argCaptionsTranscribeUrl': closeCaptions!.argCaptionsTranscribeUrl,
        'argApiKey': closeCaptions!.argApiKey,
      } : null,
    };
    return jsonEncode(configMap);
  }
}

class AutoCut{
  final String audioDataUrl;
  final String audioTracksUrl;

  AutoCut({required this.audioDataUrl, required this.audioTracksUrl});
}

class CloseCaptions{
  final String argCaprionsUploadUrl;
  final String argCaptionsTranscribeUrl;
  final String argApiKey;

  CloseCaptions({required this.argCaprionsUploadUrl, required this.argCaptionsTranscribeUrl, required this.argApiKey});
}