import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  static const SecureStorage _instance = SecureStorageImpl(
    FlutterSecureStorage(),
  );

  factory SecureStorage() => _instance;

  /// Write A String Value To The Storage
  Future<void> write({required String key, required String value});

  /// Write A JSON Value To The Storage
  Future<void> writeJSON({
    required String key,
    required Map<String, dynamic> json,
  });

  /// Read A JSON Value From The Storage
  Future<dynamic> readJSON({required String key});

  /// Remove A Value From The Storage
  Future<void> remove(String key);

  /// Read A String Value From The Storage
  Future<String?> read({required String key});

  /// Read A JSON Value From The Storage And Parse It To A Data Object
  Future<Data?> readData<Data>(
    Data Function(Map<String, dynamic>) mapper, {
    required String key,
  });
}

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _secureStorage;

  const SecureStorageImpl(this._secureStorage);

  static AndroidOptions androidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  AndroidOptions _getAndroidOptions() => androidOptions();

  @override
  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  @override
  Future<void> writeJSON({required String key, required dynamic json}) async {
    await write(key: key, value: jsonEncode(json));
  }

  @override
  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
  }

  @override
  Future<dynamic> readJSON({required String key}) async {
    final result = await read(key: key);
    if (result == null) return null;
    return jsonDecode(result);
  }

  @override
  Future<Data?> readData<Data>(
    Data Function(Map<String, dynamic>) parser, {
    required String key,
  }) async {
    final result = await read(key: key);
    if (result == null) return null;
    return parser(jsonDecode(result) as Map<String, dynamic>);
  }

  @override
  Future<void> remove(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }
}
