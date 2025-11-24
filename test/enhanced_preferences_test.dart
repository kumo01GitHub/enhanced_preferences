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

  group('String', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('set/get', () async {
      final String key = "hello";
      final String value = "World";

      expect(await prefs.setString(key, value), key);
      expect(await prefs.getString(key), value);
    });

    test('cache', () async {
      // Enable cache.
      final String key1 = "keyStringTest1";
      final String value1 = "valueStringTest1";
      final enableCacheOpts = EnhancedPreferencesOptions(enableCache: true);

      await prefs.setString(key1, value1, enableCacheOpts);
      expect(prefs.cache.containsKey(key1), true);
      expect(prefs.cache[key1], value1);
      expect(await prefs.getString(key1, enableCacheOpts), value1);

      // Disable cache.
      final String key2 = "keyStringTest2";
      final String value2 = "valueStringTest2";
      final disableCacheOpts = EnhancedPreferencesOptions(enableCache: false);

      await prefs.setString(key2, value2, disableCacheOpts);
      expect(prefs.cache.containsKey(key2), false);
      expect(await prefs.getString(key2, disableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), false);

      // Cache when get value.
      expect(await prefs.getString(key2, enableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), true);
      expect(prefs.cache[key2], value2);
      expect(await prefs.getString(key2, disableCacheOpts), value2);
    });
  });

  group('int', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('set/get', () async {
      final String key = "counter";
      final int value = 10;

      expect(await prefs.setInt(key, value), key);
      expect(await prefs.getInt(key), value);
    });

    test('cache', () async {
      // Enable cache.
      final String key1 = "keyIntTest1";
      final int value1 = 999;
      final enableCacheOpts = EnhancedPreferencesOptions(enableCache: true);

      await prefs.setInt(key1, value1, enableCacheOpts);
      expect(prefs.cache.containsKey(key1), true);
      expect(prefs.cache[key1], value1);
      expect(await prefs.getInt(key1, enableCacheOpts), value1);

      // Disable cache.
      final String key2 = "keyIntTest2";
      final int value2 = 1234;
      final disableCacheOpts = EnhancedPreferencesOptions(enableCache: false);

      await prefs.setInt(key2, value2, disableCacheOpts);
      expect(prefs.cache.containsKey(key2), false);
      expect(await prefs.getInt(key2, disableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), false);

      // Cache when get value.
      expect(await prefs.getInt(key2, enableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), true);
      expect(prefs.cache[key2], value2);
      expect(await prefs.getInt(key2, disableCacheOpts), value2);
    });
  });

  group('double', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('set/get', () async {
      final String key = "rate";
      final double value = 0.9;

      expect(await prefs.setDouble(key, value), key);
      expect(await prefs.getDouble(key), value);
    });

    test('cache', () async {
      // Enable cache.
      final String key1 = "keyDoubleTest1";
      final double value1 = 12.3;
      final enableCacheOpts = EnhancedPreferencesOptions(enableCache: true);

      await prefs.setDouble(key1, value1, enableCacheOpts);
      expect(prefs.cache.containsKey(key1), true);
      expect(prefs.cache[key1], value1);
      expect(await prefs.getDouble(key1, enableCacheOpts), value1);

      // Disable cache.
      final String key2 = "keyDoubleTest2";
      final double value2 = 0.987;
      final disableCacheOpts = EnhancedPreferencesOptions(enableCache: false);

      await prefs.setDouble(key2, value2, disableCacheOpts);
      expect(prefs.cache.containsKey(key2), false);
      expect(await prefs.getDouble(key2, disableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), false);

      // Cache when get value.
      expect(await prefs.getDouble(key2, enableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), true);
      expect(prefs.cache[key2], value2);
      expect(await prefs.getDouble(key2, disableCacheOpts), value2);
    });
  });

  group('bool', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('set/get', () async {
      final String key = "isActive";
      final bool value = true;

      expect(await prefs.setBool(key, value), key);
      expect(await prefs.getBool(key), value);
    });

    test('cache', () async {
      // Enable cache.
      final String key1 = "keyBoolTest1";
      final bool value1 = true;
      final enableCacheOpts = EnhancedPreferencesOptions(enableCache: true);

      await prefs.setBool(key1, value1, enableCacheOpts);
      expect(prefs.cache.containsKey(key1), true);
      expect(prefs.cache[key1], value1);
      expect(await prefs.getBool(key1, enableCacheOpts), value1);

      // Disable cache.
      final String key2 = "keyBoolTest2";
      final bool value2 = false;
      final disableCacheOpts = EnhancedPreferencesOptions(enableCache: false);

      await prefs.setBool(key2, value2, disableCacheOpts);
      expect(prefs.cache.containsKey(key2), false);
      expect(await prefs.getBool(key2, disableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), false);

      // Cache when get value.
      expect(await prefs.getBool(key2, enableCacheOpts), value2);
      expect(prefs.cache.containsKey(key2), true);
      expect(prefs.cache[key2], value2);
      expect(await prefs.getBool(key2, disableCacheOpts), value2);
    });
  });

  test('remove', () async {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    final String key = "keyRemoveTest";
    final String value = "valueRemoveTest";

    expect(
      await prefs.setString(
        key,
        value,
        EnhancedPreferencesOptions(enableCache: true),
      ),
      key,
    );
    expect(await prefs.getString(key), value);

    // Remove.
    expect(await prefs.remove(key), key);
    expect(() => prefs.getString(key), throwsA(isA<PlatformException>()));
    expect(prefs.cache.keys, isNot(contains(key)));
  });

  group('keys', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('retrieve all', () async {
      final String key1 = "keyKeysTest1";
      final String value1 = "valueKeysTest1";
      final String key2 = "keyKeysTest2";
      final int value2 = 999;

      await prefs.setString(
        key1,
        value1,
        EnhancedPreferencesOptions(enableCache: true),
      );
      await prefs.setInt(
        key2,
        value2,
        EnhancedPreferencesOptions(enableCache: false),
      );

      // Retrieve from platform and cache.
      final keys = await prefs.keys(false);
      expect(keys, containsAll([key1, key2]));
    });

    test('retrieve cache only', () async {
      final String key3 = "keyKeysTest3";
      final double value3 = 0.123;
      final String key4 = "keyKeysTest4";
      final bool value4 = false;

      await prefs.setDouble(
        key3,
        value3,
        EnhancedPreferencesOptions(enableCache: true),
      );
      await prefs.setBool(
        key4,
        value4,
        EnhancedPreferencesOptions(enableCache: false),
      );

      // Retrieve from cache only.
      final keys = await prefs.keys(true);
      expect(keys, containsAll([key3]));
    });
  });

  group('clear', () {
    EnhancedPreferences prefs = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform =
        MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    test('clear all', () async {
      final String key1 = "keyKeysTest1";
      final String value1 = "valueKeysTest1";
      final String key2 = "keyKeysTest2";
      final int value2 = 999;

      await prefs.setString(
        key1,
        value1,
        EnhancedPreferencesOptions(enableCache: true),
      );
      await prefs.setInt(
        key2,
        value2,
        EnhancedPreferencesOptions(enableCache: false),
      );

      // Retrieve keys.
      final keys1 = await prefs.keys();

      // Clear keys.
      final clear = await prefs.clear(false);
      final keys2 = await prefs.keys();
      expect(clear, containsAll(keys1!));
      expect(keys2, []);
    });

    test('clear cache only', () async {
      final String key3 = "keyKeysTest3";
      final double value3 = 0.123;
      final String key4 = "keyKeysTest4";
      final bool value4 = false;

      await prefs.setDouble(
        key3,
        value3,
        EnhancedPreferencesOptions(enableCache: true),
      );
      await prefs.setBool(
        key4,
        value4,
        EnhancedPreferencesOptions(enableCache: false),
      );

      // Retrieve keys.
      final keys3 = await prefs.keys(true);

      // Clear cache only.
      final clear = await prefs.clear(true);
      final keys4 = await prefs.keys(true);
      expect(clear, containsAll(keys3!));
      expect(keys4, []);
    });
  });

  test('Options', () async {
    final EnhancedPreferencesOptions options = EnhancedPreferencesOptions();

    expect(options.enableCache, true);
    expect(options.enableEncryption, false);
  });

  test('Unsupported type', () {
    EnhancedPreferences prefs = EnhancedPreferences();

    expect(
      () => prefs.setItem<Object>("key", Object()),
      throwsA(isA<TypeError>()),
    );
    expect(() => prefs.getItem<Object>("key"), throwsA(isA<TypeError>()));
  });
}
