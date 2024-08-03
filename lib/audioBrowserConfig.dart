import 'package:flutter/material.dart';

enum Source {soundstripe, local}

@immutable
class AudioBrowser {
  final Source source;
  final Map<String, dynamic>? params;

  const AudioBrowser._({required this.source, this.params});

  factory AudioBrowser.fromSource(Source source, {Map<String, dynamic>? params}) {
    return AudioBrowser._(source: source, params: params);
  }

  Map<String, dynamic> toJson(){
    return {
      'source' : source.name,
      'params' : params,
    };
  }
}