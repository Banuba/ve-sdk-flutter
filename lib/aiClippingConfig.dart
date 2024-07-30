import 'package:flutter/material.dart';

@immutable
class AiClipping{
  final String audioDataUrl;
  final String audioTracksUrl;

  const AiClipping({required this.audioDataUrl, required this.audioTracksUrl});

  Map<String, dynamic> toJson(){
    return {
      'audioDataUrl': audioDataUrl,
      'audioTracksUrl': audioTracksUrl,
    };
  }
}