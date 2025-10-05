// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:enhanced_preferences/enhanced_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final EnhancedPreferences prefs = EnhancedPreferences();

  test('setString/getString', () async {
    final String key = "hello";
    final String value = "World";

    expect(await prefs.setString(key, value), key);
    expect(await prefs.getString(key), value);
  });

  test('setInt/getInt', () async {
    final String key = "counter";
    final int value = 10;

    expect(await prefs.setInt(key, value), key);
    expect(await prefs.getInt(key), value);
  });

  test('setDouble/getDouble', () async {
    final String key = "rate";
    final double value = 0.9;

    expect(await prefs.setDouble(key, value), key);
    expect(await prefs.getDouble(key), value);
  });

  test('setBool/getBool', () async {
    final String key = "isActive";
    final bool value = true;

    expect(await prefs.setBool(key, value), key);
    expect(await prefs.getBool(key), value);
  });

  test('keys', () async {
    final EnhancedPreferencesOptions options = EnhancedPreferencesOptions(
      enableCache: false,
    );

    final String key1 = "key1";
    final int value1 = 999;
    final String key2 = "key2";
    final bool value2 = false;

    expect(await prefs.setInt(key1, value1, options), key1);
    expect(await prefs.setBool(key2, value2, options), key2);
    expect(await prefs.keys(), containsAll([key1, key2]));

    expect(await prefs.remove(key1), key1);
    expect((await prefs.keys())?.contains(key1), false);
    expect((await prefs.keys())?.contains(key2), true);
  });

  test('Cache', () async {
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

  test('Encryption', () async {
    final String key1 = "plainKey";
    final String value1 = "plainValue";
    await prefs.setString(
      key1,
      value1,
      EnhancedPreferencesOptions(enableCache: false, enableEncryption: false),
    );

    final String key2 = "encryptedKey";
    final String value2 = "encryptedValue";
    await prefs.setString(
      key2,
      value2,
      EnhancedPreferencesOptions(enableCache: false, enableEncryption: true),
    );

    expect(
      await prefs.getString(
        key1,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: false),
      ),
      value1,
    );
    expect(
      () => prefs.getString(
        key1,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: true),
      ),
      throwsA(isA<PlatformException>()),
    );

    expect(
      await prefs.getString(
        key2,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: true),
      ),
      value2,
    );
    expect(
      () => prefs.getString(
        key2,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: false),
      ),
      throwsA(isA<PlatformException>()),
    );
  }, skip: true);
}
