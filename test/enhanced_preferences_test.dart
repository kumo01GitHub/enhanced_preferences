import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_preferences/enhanced_preferences.dart';
import 'package:enhanced_preferences/enhanced_preferences_platform_interface.dart';
import 'package:enhanced_preferences/enhanced_preferences_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEnhancedPreferencesPlatform
    with MockPlatformInterfaceMixin
    implements EnhancedPreferencesPlatform {
  final Map<String, dynamic> _preferences = {};

  @override
  Future<String?> getString(String key) {
    return Future.value(_preferences[key] as String?);
  }

  @override
  Future<String?> setString(String key, String value) {
    _preferences[key] = value;
    return Future.value(key);
  }

  @override
  Future<int?> getInt(String key) {
    return Future.value(_preferences[key] as int?);
  }

  @override
  Future<String?> setInt(String key, int value) {
    _preferences[key] = value;
    return Future.value(key);
  }

  @override
  Future<double?> getDouble(String key) {
    return Future.value(_preferences[key] as double?);
  }

  @override
  Future<String?> setDouble(String key, double value) {
    _preferences[key] = value;
    return Future.value(key);
  }

  @override
  Future<bool?> getBool(String key) {
    return Future.value(_preferences[key] as bool?);
  }
  
  @override
  Future<String?> setBool(String key, bool value) {
    _preferences[key] = value;
    return Future.value(key);
  }
}

void main() {
  final EnhancedPreferencesPlatform initialPlatform = EnhancedPreferencesPlatform.instance;

  test('$MethodChannelEnhancedPreferences is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEnhancedPreferences>());
  });

  test('String', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform = MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "stringKey";
    final String value = "stringValue";

    expect(await enhancedPreferencesPlugin.setString(key, value), key);
    expect(await enhancedPreferencesPlugin.getString(key), value);
  });

  test('Int', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform = MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "intKey";
    final int value = 999;

    expect(await enhancedPreferencesPlugin.setInt(key, value), key);
    expect(await enhancedPreferencesPlugin.getInt(key), value);
  });

  test('Double', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform = MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "doubleKey";
    final double value = 999.99;

    expect(await enhancedPreferencesPlugin.setDouble(key, value), key);
    expect(await enhancedPreferencesPlugin.getDouble(key), value);
  });

  test('Bool', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform = MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "boolKey";
    final bool value = true;

    expect(await enhancedPreferencesPlugin.setBool(key, value), key);
    expect(await enhancedPreferencesPlugin.getBool(key), value);
  });
}
