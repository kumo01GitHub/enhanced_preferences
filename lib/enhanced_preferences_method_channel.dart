import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'enhanced_preferences_platform_interface.dart';

/// An implementation of [EnhancedPreferencesPlatform] that uses method channels.
class MethodChannelEnhancedPreferences extends EnhancedPreferencesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('enhanced_preferences');

  @override
  Future<String?> getString(String key) async {
    final value = await methodChannel.invokeMethod<String>('getString', { 'key': key });
    return value;
  }

  @override
  Future<String?> setString(String key, String value) async {
    final result = await methodChannel.invokeMethod<String>('setString', { 'key': key, 'value': value });
    return result;
  }

  @override
  Future<int?> getInt(String key) async {
    final value = await methodChannel.invokeMethod<int>('getInt', { 'key': key });
    return value;
  }

  @override
  Future<String?> setInt(String key, int value) async {
    final result = await methodChannel.invokeMethod<String>('setInt', { 'key': key, 'value': value });
    return result;
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = await methodChannel.invokeMethod<double>('getDouble', { 'key': key });
    return value;
  }

  @override
  Future<String?> setDouble(String key, double value) async {
    final result = await methodChannel.invokeMethod<String>('setDouble', { 'key': key, 'value': value });
    return result;
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = await methodChannel.invokeMethod<bool>('getBool', { 'key': key });
    return value;
  }

  @override
  Future<String?> setBool(String key, bool value) async {
    final result = await methodChannel.invokeMethod<String>('setBool', { 'key': key, 'value': value });
    return result;
  }
}
