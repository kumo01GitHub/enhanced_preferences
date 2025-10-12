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

  group('String', () {
    test('set/get', () async {
      final opts = EnhancedPreferencesOptions(enableCache: false);
      final String key = "hello";
      final String value = "World";

      expect(await prefs.setString(key, value, opts), key);
      expect(await prefs.getString(key, opts), value);
    });
  });

  group('int', () {
    test('set/get', () async {
      final opts = EnhancedPreferencesOptions(enableCache: false);
      final String key = "counter";
      final int value = 10;

      expect(await prefs.setInt(key, value, opts), key);
      expect(await prefs.getInt(key, opts), value);
    });
  });

  group('double', () {
    test('set/get', () async {
      final opts = EnhancedPreferencesOptions(enableCache: false);
      final String key = "rate";
      final double value = 0.9;

      expect(await prefs.setDouble(key, value, opts), key);
      expect(await prefs.getDouble(key, opts), value);
    });
  });

  group('bool', () {
    test('set/get', () async {
      final opts = EnhancedPreferencesOptions(enableCache: false);
      final String key = "isActive";
      final bool value = true;

      expect(await prefs.setBool(key, value, opts), key);
      expect(await prefs.getBool(key, opts), value);
    });
  });

  test('remove', () async {
    final String key = "keyToRemove";
    final String value = "valueToRemove";

    expect(await prefs.setString(key, value), key);
    expect(await prefs.getString(key), value);
    expect(await prefs.remove(key), key);
    expect(() => prefs.getString(key), throwsA(isA<PlatformException>()));
  });

  test('keys', () async {
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
      prefs.getString(
        key1,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: false),
      ),
      completion(value1),
    );
    expect(
      prefs.getString(
        key1,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: true),
      ),
      throwsA(isA<PlatformException>()),
    );

    expect(
      prefs.getString(
        key2,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: true),
      ),
      completion(value2),
    );
    expect(
      prefs.getString(
        key2,
        EnhancedPreferencesOptions(enableCache: false, enableEncryption: false),
      ),
      throwsA(isA<PlatformException>()),
    );
  });
}
