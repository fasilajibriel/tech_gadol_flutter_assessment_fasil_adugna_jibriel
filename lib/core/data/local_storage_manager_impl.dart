// core/data/services/secure_storage_handler.dart
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/local_storage_manager.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';

class LocalStorageManagerImpl implements LocalStorageManager {
  final FlutterSecureStorage _storage;

  LocalStorageManagerImpl(this._storage);

  @override
  FutureResult<void> writeString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(message: 'Write failed: ${e.toString()}'));
    }
  }

  @override
  FutureResult<void> writeMap(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await writeString(key, jsonString);
    } on Exception catch (e) {
      return Left(DataParsingFailure(message: 'Map serialization failed: ${e.toString()}'));
    }
  }

  @override
  FutureResult<String> readString(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null ? Right(value) : Left(StorageFailure(message: 'Key "$key" not found'));
    } catch (e) {
      return Left(StorageFailure(message: 'Read failed: ${e.toString()}'));
    }
  }

  @override
  FutureResult<Map<String, dynamic>> readMap(String key) async {
    final stringResult = await readString(key);
    return stringResult.fold((failure) => Left(failure), (jsonString) {
      try {
        return Right(jsonDecode(jsonString) as Map<String, dynamic>);
      } on Exception catch (e) {
        return Left(DataParsingFailure(message: 'Map parsing failed: ${e.toString()}'));
      }
    });
  }

  @override
  FutureResult<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(message: 'Delete failed: ${e.toString()}'));
    }
  }

  @override
  FutureResult<void> clearAll() async {
    try {
      await _storage.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(message: 'Clear failed: ${e.toString()}'));
    }
  }
}
