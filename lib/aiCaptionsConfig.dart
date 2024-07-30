import 'package:flutter/material.dart';

@immutable
class AiCaptions{
  final String uploadUrl;
  final String transcribeUrl;
  final String apiKey;

  const AiCaptions({required this.uploadUrl, required this.transcribeUrl, required this.apiKey});

  Map<String, dynamic> toJson(){
    return {
      'uploadUrl': uploadUrl,
      'transcribeUrl': transcribeUrl,
      'apiKey': apiKey,
    };
  }
}