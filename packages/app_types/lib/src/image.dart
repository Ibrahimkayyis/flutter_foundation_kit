import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file/local.dart' show LocalFileSystem;
import 'package:flutter/material.dart';
import 'package:file/file.dart';

String _baseURL = "";

FileSystem _fileSystem = const LocalFileSystem();

enum AppImageType { network, file, memory }

sealed class AppImage extends Equatable {
  final String? _name;
  final AppImageType type;

  static const String className = "image";

  static void init({
    String? baseURL,
    FileSystem fileSystem = const LocalFileSystem(),
    Map<String, String> Function()? headerBuilder,
  }) {
    _baseURL = baseURL ?? "";
    _fileSystem = fileSystem;
  }

  static String get baseURL => _baseURL;

  const AppImage({String? name, required this.type}) : _name = name;

  String? get name => _name;

  @override
  List<Object?> get props => [name];

  ImageProvider get provider;

  dynamic toJSON() {
    return {"type": type.toString()};
  }

  static AppImage? tryFromJSON(Map<String, dynamic> json) {
    try {
      return AppImage.fromJSON(json);
    } catch (e) {
      return null;
    }
  }

  factory AppImage.fromJSON(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = AppImageType.values.firstWhere(
      (e) => e.toString() == typeString,
      orElse: () => throw ArgumentError('Invalid image type'),
    );

    switch (type) {
      case AppImageType.network:
        return AppNetworkImage(
          baseUrl: json['baseUrl'] as String,
          path: json['path'] as String,
          headers:
              json['headers'] != null
                  ? Map<String, String>.from(json['headers'])
                  : null,
        );
      case AppImageType.file:
        return AppFileImage(
          filepath: json['filepath'] as String,
          name: json['name'] as String,
        );
      case AppImageType.memory:
        return AppMemoryImage(
          filepath: json['filepath'] as String?,
          image: json['image'] as String,
          bytes: base64.decode(json['bytes'] as String),
        );
    }
  }
}

class AppNetworkImage extends AppImage {
  final String baseUrl;
  final String path;
  final Map<String, String>? headers;

  const AppNetworkImage({
    required this.baseUrl,
    required this.path,
    this.headers,
  }) : super(type: AppImageType.network);

  factory AppNetworkImage.build(
    String path, {
    String? baseUrl,
    Map<String, String>? headers,
  }) => AppNetworkImage(
    baseUrl: baseUrl ?? _baseURL,
    path: path,
    headers: headers,
  );

  String _buildURL(String path) => "$baseUrl$path";

  String get url => _buildURL(path);

  @override
  List<Object?> get props => [...super.props, baseUrl, path];

  @override
  ImageProvider<Object> get provider => NetworkImage(url, headers: headers);

  @override
  dynamic toJSON() {
    return {
      ...super.toJSON(),
      "baseUrl": baseUrl,
      "path": path,
      "headers": headers,
    };
  }
}

class AppCompleteNetworkImage extends AppNetworkImage {
  final String imageXS;
  final String imageSM;
  final String imageNormal;

  const AppCompleteNetworkImage({
    required this.imageXS,
    required this.imageSM,
    required this.imageNormal,
    required super.baseUrl,
  }) : super(path: imageNormal);

  factory AppCompleteNetworkImage.build({
    String? baseUrl,
    required String imageXS,
    required String imageSM,
    required String imageNormal,
  }) {
    final url = baseUrl ?? _baseURL;
    return AppCompleteNetworkImage(
      imageXS: imageXS,
      imageSM: imageSM,
      imageNormal: imageNormal,
      baseUrl: url,
    );
  }

  factory AppCompleteNetworkImage.fromJSON(
    Map<String, dynamic> json, {
    String? baseUrl,
  }) {
    final url = baseUrl ?? _baseURL;

    return AppCompleteNetworkImage(
      imageXS: json["imageExtraSmallUrl"],
      imageSM: json["imageSmallUrl"],
      imageNormal: json["imageNormalUrl"],
      baseUrl: url,
    );
  }

  ImageProvider get providerXS =>
      NetworkImage(_buildURL(imageXS), headers: headers);

  ImageProvider get providerSM =>
      NetworkImage(_buildURL(imageSM), headers: headers);

  @override
  List<Object?> get props => [imageXS, imageSM, imageNormal];
}

class AppFileImage extends AppImage {
  final String _requiredName;
  final String filepath;

  const AppFileImage({required this.filepath, required String name})
    : _requiredName = name,
      super(name: name, type: AppImageType.file);

  @override
  String get name => _requiredName;

  @override
  ImageProvider<Object> get provider => FileImage(_fileSystem.file(filepath));

  @override
  List<Object?> get props => [...super.props, filepath];

  @override
  dynamic toJSON() {
    return {...super.toJSON(), "filepath": filepath, "name": name};
  }
}

class AppMemoryImage extends AppImage {
  final String image;
  final String? filepath;
  final Uint8List bytes;

  const AppMemoryImage({
    required this.image,
    required this.bytes,
    this.filepath,
  }) : super(type: AppImageType.memory);

  @override
  ImageProvider<Object> get provider => MemoryImage(bytes);

  @override
  dynamic toJSON() {
    return {
      ...super.toJSON(),
      "image": image,
      "bytes": base64.encode(bytes),
      "filepath": filepath,
    };
  }

  @override
  List<Object?> get props => [...super.props, filepath, filepath];
}


typedef NTIImage = AppImage;
typedef NTINetworkImage = AppNetworkImage;
typedef NTICompleteNetworkImage = AppCompleteNetworkImage;
typedef NTIFileImage = AppFileImage;
typedef NTIMemoryImage = AppMemoryImage;
