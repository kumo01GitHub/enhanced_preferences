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

  test('setString/getString', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "stringKey";
    final String value = "stringValue";

    expect(await prefs.setString(key, value), key);
    expect(await prefs.getString(key), value);
  });

  test('setInt/getInt', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "intKey";
    final int value = 999;

    expect(await prefs.setInt(key, value), key);
    expect(await prefs.getInt(key), value);
  });

  test('setDouble/getDouble', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "doubleKey";
    final double value = 999.99;

    expect(await prefs.setDouble(key, value), key);
    expect(await prefs.getDouble(key), value);
  });

  test('setBool/getBool', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "boolKey";
    final bool value = true;

    expect(await prefs.setBool(key, value), key);
    expect(await prefs.getBool(key), value);
  });

  test('remove', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "keyToRemove";
    final String value = "valueToRemove";

    expect(await prefs.setString(key, value), key);
    expect(await prefs.getString(key), value);
    expect(await prefs.remove(key), key);
    expect(() => prefs.getString(key), throwsA(isA<PlatformException>()));
  });

  test('keys', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key1 = "key1";
    final int value1 = 999;
    final String key2 = "key2";
    final bool value2 = false;

    expect(await prefs.setInt(key1, value1), key1);
    expect(await prefs.setBool(key2, value2), key2);
    expect(await prefs.keys(), containsAll([key1, key2]));

    expect(await prefs.remove(key1), key1);
    expect((await prefs.keys())?.contains(key1), false);
    expect((await prefs.keys())?.contains(key2), true);
  });

  test('Options', () async {
    final EnhancedPreferencesOptions options = EnhancedPreferencesOptions();

    expect(options.enableCache, true);
    expect(options.enableEncryption, false);
  });

  test('Cache', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key1 = "cachedKey";
    final double value1 = 1.23;

    await prefs.setDouble(
      key1,
      value1,
      EnhancedPreferencesOptions(enableCache: true),
    );
    expect(prefs.cache.containsKey(key1), true);

    final String key2 = "nonCachedKey";
    final double value2 = 98.76;

    await prefs.setDouble(
      key2,
      value2,
      EnhancedPreferencesOptions(enableCache: false),
    );
    expect(prefs.cache.containsKey(key2), false);
  });
}
