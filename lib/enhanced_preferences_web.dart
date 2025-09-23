// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'enhanced_preferences_platform_interface.dart';

/// A web implementation of the EnhancedPreferencesPlatform of the EnhancedPreferences plugin.
class EnhancedPreferencesWeb extends EnhancedPreferencesPlatform {
  /// Constructs a EnhancedPreferencesWeb
  EnhancedPreferencesWeb();

  /// Prefix for keys to avoid collision.
  static const String _keyPrefix = 'FEP@';

  static void registerWith(Registrar registrar) {
    EnhancedPreferencesPlatform.instance = EnhancedPreferencesWeb();
  }

  @override
  Future<String?> getString(String key, [bool enableEncryption = false]) {
    return Future<String?>.value(_getItem(key));
  }

  @override
  Future<String?> setString(
    String key,
    String value, [
    bool enableEncryption = false,
  ]) {
    return Future<String?>.value(_setItem(key, value));
  }

  @override
  Future<int?> getInt(String key, [bool enableEncryption = false]) {
    int? value = int.tryParse(_getItem(key));
    if (value == null) {
      throw Exception('REFERENCE_ERROR');
    } else {
      return Future<int?>.value(value);
    }
  }

  @override
  Future<String?> setInt(
    String key,
    int value, [
    bool enableEncryption = false,
  ]) {
    return Future<String?>.value(_setItem(key, value.toString()));
  }

  @override
  Future<double?> getDouble(String key, [bool enableEncryption = false]) {
    double? value = double.tryParse(_getItem(key));
    if (value == null) {
      throw Exception('REFERENCE_ERROR');
    } else {
      return Future<double?>.value(value);
    }
  }

  @override
  Future<String?> setDouble(
    String key,
    double value, [
    bool enableEncryption = false,
  ]) {
    return Future<String?>.value(_setItem(key, value.toString()));
  }

  @override
  Future<bool?> getBool(String key, [bool enableEncryption = false]) {
    bool? value = bool.tryParse(_getItem(key));
    if (value == null) {
      throw Exception('REFERENCE_ERROR');
    } else {
      return Future<bool?>.value(value);
    }
  }

  @override
  Future<String?> setBool(
    String key,
    bool value, [
    bool enableEncryption = false,
  ]) {
    return Future<String?>.value(_setItem(key, value.toString()));
  }

  @override
  Future<String?> remove(String key) {
    return Future<String?>.value(_removeItem(key));
  }

  String _getItem(String key) {
    if (key.isEmpty) {
      throw Exception('INVALID_ARGUMENT');
    }

    String? value = web.window.localStorage.getItem("$_keyPrefix$key");

    if (value == null) {
      throw Exception('REFERENCE_ERROR');
    } else {
      return value;
    }
  }

  String _setItem(String key, String value) {
    if (key.isEmpty) {
      throw Exception('INVALID_ARGUMENT');
    }

    web.window.localStorage.setItem("$_keyPrefix$key", value);
    return key;
  }

  String _removeItem(String key) {
    if (key.isEmpty) {
      throw Exception('INVALID_ARGUMENT');
    }

    web.window.localStorage.removeItem("$_keyPrefix$key");
    return key;
  }
}
