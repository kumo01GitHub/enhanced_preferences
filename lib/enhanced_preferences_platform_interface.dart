import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'enhanced_preferences_method_channel.dart';

abstract class EnhancedPreferencesPlatform extends PlatformInterface {
  /// Constructs a EnhancedPreferencesPlatform.
  EnhancedPreferencesPlatform() : super(token: _token);

  static final Object _token = Object();

  static EnhancedPreferencesPlatform _instance =
      MethodChannelEnhancedPreferences();

  /// The default instance of [EnhancedPreferencesPlatform] to use.
  ///
  /// Defaults to [MethodChannelEnhancedPreferences].
  static EnhancedPreferencesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EnhancedPreferencesPlatform] when
  /// they register themselves.
  static set instance(EnhancedPreferencesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getString(String key) {
    throw UnimplementedError('getString() has not been implemented.');
  }

  Future<String?> setString(String key, String value) {
    throw UnimplementedError('setString() has not been implemented.');
  }

  Future<int?> getInt(String key) {
    throw UnimplementedError('getInt() has not been implemented.');
  }

  Future<String?> setInt(String key, int value) {
    throw UnimplementedError('setInt() has not been implemented.');
  }

  Future<double?> getDouble(String key) {
    throw UnimplementedError('getDouble() has not been implemented.');
  }

  Future<String?> setDouble(String key, double value) {
    throw UnimplementedError('setDouble() has not been implemented.');
  }

  Future<bool?> getBool(String key) {
    throw UnimplementedError('getBool() has not been implemented.');
  }

  Future<String?> setBool(String key, bool value) {
    throw UnimplementedError('setBool() has not been implemented.');
  }
}
