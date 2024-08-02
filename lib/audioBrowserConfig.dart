import 'package:flutter/material.dart';

enum Source {soundstripe, local}

@immutable
class AudioBrowser {
  final Source source;
  final Map<String, dynamic>? params;

  const AudioBrowser({required this.source, this.params});

  Map<String, dynamic> toJson(){
    return {
      'source' : source.name,
      'params' : params,
    };
  }
}