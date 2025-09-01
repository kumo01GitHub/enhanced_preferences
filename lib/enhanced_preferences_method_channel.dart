import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'enhanced_preferences_platform_interface.dart';

/// An implementation of [EnhancedPreferencesPlatform] that uses method channels.
class MethodChannelEnhancedPreferences extends EnhancedPreferencesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('enhanced_preferences');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

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
}
