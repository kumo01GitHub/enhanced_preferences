import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'enhanced_preferences_platform_interface.dart';

/// An implementation of [EnhancedPreferencesPlatform] that uses method channels.
class MethodChannelEnhancedPreferences extends EnhancedPreferencesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('enhanced_preferences');

  @override
  Future<String?> getString(String key, [bool enableEncryption = false]) async {
    final value = await methodChannel.invokeMethod<String>('getString', {
      'key': key,
      'enableEncryption': enableEncryption,
    });
    return value;
  }

  @override
  Future<String?> setString(
    String key,
    String value, [
    bool enableEncryption = false,
  ]) async {
    final result = await methodChannel.invokeMethod<String>('setString', {
      'key': key,
      'value': value,
      'enableEncryption': enableEncryption,
    });
    return result;
  }

  @override
  Future<int?> getInt(String key, [bool enableEncryption = false]) async {
    final value = await methodChannel.invokeMethod<int>('getInt', {
      'key': key,
      'enableEncryption': enableEncryption,
    });
    return value;
  }

  @override
  Future<String?> setInt(
    String key,
    int value, [
    bool enableEncryption = false,
  ]) async {
    final result = await methodChannel.invokeMethod<String>('setInt', {
      'key': key,
      'value': value,
      'enableEncryption': enableEncryption,
    });
    return result;
  }

  @override
  Future<double?> getDouble(String key, [bool enableEncryption = false]) async {
    final value = await methodChannel.invokeMethod<double>('getDouble', {
      'key': key,
      'enableEncryption': enableEncryption,
    });
    return value;
  }

  @override
  Future<String?> setDouble(
    String key,
    double value, [
    bool enableEncryption = false,
  ]) async {
    final result = await methodChannel.invokeMethod<String>('setDouble', {
      'key': key,
      'value': value,
      'enableEncryption': enableEncryption,
    });
    return result;
  }

  @override
  Future<bool?> getBool(String key, [bool enableEncryption = false]) async {
    final value = await methodChannel.invokeMethod<bool>('getBool', {
      'key': key,
      'enableEncryption': enableEncryption,
    });
    return value;
  }

  @override
  Future<String?> setBool(
    String key,
    bool value, [
    bool enableEncryption = false,
  ]) async {
    final result = await methodChannel.invokeMethod<String>('setBool', {
      'key': key,
      'value': value,
      'enableEncryption': enableEncryption,
    });
    return result;
  }

  @override
  Future<String?> remove(String key) async {
    final result = await methodChannel.invokeMethod<String>('remove', {
      'key': key,
    });
    return result;
  }

  @override
  Future<List<String>?> keys() async {
    final result = await methodChannel.invokeMethod<List<String>>('keys');
    return result;
  }
}
