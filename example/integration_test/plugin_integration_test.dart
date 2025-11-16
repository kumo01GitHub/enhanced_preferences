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

    test('encryption', () async {
      final enableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: true,
      );
      final disableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: false,
      );

      String key1 = "encryptedStringKey";
      String value1 = "encryptedStringValue";
      expect(await prefs.setString(key1, value1, enableEncryptionOpts), key1);
      expect(await prefs.getString(key1, enableEncryptionOpts), value1);
      expect(
        () => prefs.getString(key1, disableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );

      String key2 = "plainStringKey";
      String value2 = "plainStringValue";
      expect(await prefs.setString(key2, value2, disableEncryptionOpts), key2);
      expect(await prefs.getString(key2, disableEncryptionOpts), value2);
      expect(
        () => prefs.getString(key2, enableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );
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

    test('encryption', () async {
      final enableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: true,
      );
      final disableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: false,
      );

      String key1 = "encryptedIntKey";
      int value1 = 999;
      expect(await prefs.setInt(key1, value1, enableEncryptionOpts), key1);
      expect(await prefs.getInt(key1, enableEncryptionOpts), value1);
      expect(
        () => prefs.getInt(key1, disableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );

      String key2 = "plainIntKey";
      int value2 = 1234;
      expect(await prefs.setInt(key2, value2, disableEncryptionOpts), key2);
      expect(await prefs.getInt(key2, disableEncryptionOpts), value2);
      expect(
        () => prefs.getInt(key2, enableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );
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

    test('encryption', () async {
      final enableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: true,
      );
      final disableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: false,
      );

      String key1 = "encryptedDoubleKey";
      double value1 = 12.3;
      expect(await prefs.setDouble(key1, value1, enableEncryptionOpts), key1);
      expect(await prefs.getDouble(key1, enableEncryptionOpts), value1);
      expect(
        () => prefs.getDouble(key1, disableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );

      String key2 = "plainDoubleKey";
      double value2 = 0.987;
      expect(await prefs.setDouble(key2, value2, disableEncryptionOpts), key2);
      expect(await prefs.getDouble(key2, disableEncryptionOpts), value2);
      expect(
        () => prefs.getDouble(key2, enableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );
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

    test('encryption', () async {
      final enableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: true,
      );
      final disableEncryptionOpts = EnhancedPreferencesOptions(
        enableCache: false,
        enableEncryption: false,
      );

      String key1 = "encryptedBoolKey";
      bool value1 = true;
      expect(await prefs.setBool(key1, value1, enableEncryptionOpts), key1);
      expect(await prefs.getBool(key1, enableEncryptionOpts), value1);
      expect(
        () => prefs.getBool(key1, disableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );

      String key2 = "plainBoolKey";
      bool value2 = false;
      expect(await prefs.setBool(key2, value2, disableEncryptionOpts), key2);
      expect(await prefs.getBool(key2, disableEncryptionOpts), value2);
      expect(
        () => prefs.getBool(key2, enableEncryptionOpts),
        throwsA(isA<PlatformException>()),
      );
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
        key1, value1, EnhancedPreferencesOptions(enableCache: true)
      );
      await prefs.setInt(
        key2, value2, EnhancedPreferencesOptions(enableCache: false)
      );

      // Retrieve from platform and cache.
      final keys = await prefs.keys(false);
      expect(keys, containsAll([key1, key2]));
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
        key1, value1, EnhancedPreferencesOptions(enableCache: true)
      );
      await prefs.setInt(
        key2, value2, EnhancedPreferencesOptions(enableCache: false)
      );

      // Retrieve keys.
      final keys1 = await prefs.keys();

      // Clear keys.
      final clear = await prefs.clear(false);
      final keys2 = await prefs.keys();
      expect(clear, keys1);
      expect(keys2, []);
    });
  });
}
