import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_preferences/enhanced_preferences.dart';
import 'package:enhanced_preferences/enhanced_preferences_platform_interface.dart';
import 'package:enhanced_preferences/enhanced_preferences_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEnhancedPreferencesPlatform
    with MockPlatformInterfaceMixin
    implements EnhancedPreferencesPlatform {
  final Map<String, dynamic> _preferences = {};

  Future<T?> _getItem<T>(String key) {
    if (_preferences.containsKey(key)) {
      return Future.value(_preferences[key] as T?);
    } else {
      throw PlatformException(
        code: 'REFERENCE_ERROR',
        message: 'Reference Error',
      );
    }
  }

  Future<String?> _setItem<T>(String key, T value) {
    _preferences[key] = value;
    return Future.value(key);
  }

  @override
  Future<String?> getString(String key, [bool enableEncryption = false]) {
    return _getItem<String>(key);
  }

  @override
  Future<String?> setString(
    String key,
    String value, [
    bool enableEncryption = false,
  ]) {
    return _setItem<String>(key, value);
  }

  @override
  Future<int?> getInt(String key, [bool enableEncryption = false]) {
    return _getItem<int>(key);
  }

  @override
  Future<String?> setInt(
    String key,
    int value, [
    bool enableEncryption = false,
  ]) {
    return _setItem<int>(key, value);
  }

  @override
  Future<double?> getDouble(String key, [bool enableEncryption = false]) {
    return _getItem<double>(key);
  }

  @override
  Future<String?> setDouble(
    String key,
    double value, [
    bool enableEncryption = false,
  ]) {
    return _setItem<double>(key, value);
  }

  @override
  Future<bool?> getBool(String key, [bool enableEncryption = false]) {
    return _getItem<bool>(key);
  }

  @override
  Future<String?> setBool(
    String key,
    bool value, [
    bool enableEncryption = false,
  ]) {
    return _setItem<bool>(key, value);
  }

  @override
  Future<String?> remove(String key) {
    _preferences.remove(key);
    return Future.value(key);
  }

  @override
  Future<List<String>?> keys() {
    return Future.value(_preferences.keys.toList());
  }
}

void main() {
  final EnhancedPreferencesPlatform initialPlatform =
      EnhancedPreferencesPlatform.instance;

  test('$MethodChannelEnhancedPreferences is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEnhancedPreferences>());
  });

  test('String', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "stringKey";
    final String value = "stringValue";

    expect(await enhancedPreferencesPlugin.setString(key, value), key);
    expect(await enhancedPreferencesPlugin.getString(key), value);
  });

  test('Int', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "intKey";
    final int value = 999;

    expect(await enhancedPreferencesPlugin.setInt(key, value), key);
    expect(await enhancedPreferencesPlugin.getInt(key), value);
  });

  test('Double', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "doubleKey";
    final double value = 999.99;

    expect(await enhancedPreferencesPlugin.setDouble(key, value), key);
    expect(await enhancedPreferencesPlugin.getDouble(key), value);
  });

  test('Bool', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "boolKey";
    final bool value = true;

    expect(await enhancedPreferencesPlugin.setBool(key, value), key);
    expect(await enhancedPreferencesPlugin.getBool(key), value);
  });

  test('Remove', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "keyToRemove";
    final String value = "valueToRemove";

    expect(await enhancedPreferencesPlugin.setString(key, value), key);
    expect(await enhancedPreferencesPlugin.getString(key), value);
    expect(await enhancedPreferencesPlugin.remove(key), key);
    expect(
      () => enhancedPreferencesPlugin.getString(key),
      throwsA(isA<PlatformException>()),
    );
  });

  test('Keys', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key1 = "key1";
    final int value1 = 999;
    final String key2 = "key2";
    final bool value2 = false;

    expect(await enhancedPreferencesPlugin.setInt(key1, value1), key1);
    expect(await enhancedPreferencesPlugin.setBool(key2, value2), key2);
    expect(await enhancedPreferencesPlugin.keys(), containsAll([key1, key2]));

    expect(await enhancedPreferencesPlugin.remove(key1), key1);
    expect((await enhancedPreferencesPlugin.keys())?.contains(key1), false);
    expect(await enhancedPreferencesPlugin.keys(), containsAll([key2]));
  });
}
