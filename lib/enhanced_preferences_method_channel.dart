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
}
