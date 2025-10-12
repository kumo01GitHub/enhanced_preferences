import 'package:flutter/foundation.dart' show visibleForTesting;

import 'enhanced_preferences_platform_interface.dart';

/// Options for EnhancedPreferences.
class EnhancedPreferencesOptions {
  /// Whether to enable cache. Default is true.
  final bool enableCache;

  /// Whether to enable encryption. Default is false.
  final bool enableEncryption;

  const EnhancedPreferencesOptions({
    this.enableCache = true,
    this.enableEncryption = false,
  });
}

/// A implementation of the EnhancedPreferencesPlatform.
class EnhancedPreferences {
  /// Cache.
  @visibleForTesting
  final Map<String, dynamic> cache = {};

  /// Get the string value for the given key.
  Future<String?> getString(String key, [EnhancedPreferencesOptions? options]) {
    return getItem<String>(key, options);
  }

  /// Set the string value for the given key.
  Future<String?> setString(
    String key,
    String value, [
    EnhancedPreferencesOptions? options,
  ]) {
    return setItem<String>(key, value, options);
  }

  /// Get the integer value for the given key.
  Future<int?> getInt(String key, [EnhancedPreferencesOptions? options]) {
    return getItem<int>(key, options);
  }

  /// Set the integer value for the given key.
  Future<String?> setInt(
    String key,
    int value, [
    EnhancedPreferencesOptions? options,
  ]) {
    return setItem<int>(key, value, options);
  }

  /// Get the double value for the given key.
  Future<double?> getDouble(String key, [EnhancedPreferencesOptions? options]) {
    return getItem<double>(key, options);
  }

  /// Set the double value for the given key.
  Future<String?> setDouble(
    String key,
    double value, [
    EnhancedPreferencesOptions? options,
  ]) {
    return setItem<double>(key, value, options);
  }

  /// Get the boolean value for the given key.
  Future<bool?> getBool(String key, [EnhancedPreferencesOptions? options]) {
    return getItem<bool>(key, options);
  }

  /// Set the boolean value for the given key.
  Future<String?> setBool(
    String key,
    bool value, [
    EnhancedPreferencesOptions? options,
  ]) {
    return setItem<bool>(key, value, options);
  }

  /// Remove an entry.
  Future<String?> remove(String key) {
    return EnhancedPreferencesPlatform.instance.remove(key).then((String? key) {
      cache.remove(key);
      return key;
    });
  }

  /// Get keys.
  Future<List<String>?> keys() {
    return EnhancedPreferencesPlatform.instance.keys();
  }

  /// Get item.
  @visibleForTesting
  Future<T?> getItem<T>(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && cache.containsKey(key) && cache[key] is T) {
      return Future.value(cache[key] as T?);
    } else {
      Future<T?> storedValue;

      if (T == String) {
        storedValue =
            EnhancedPreferencesPlatform.instance.getString(
                  key,
                  opts.enableEncryption,
                )
                as Future<T?>;
      } else if (T == int) {
        storedValue =
            EnhancedPreferencesPlatform.instance.getInt(
                  key,
                  opts.enableEncryption,
                )
                as Future<T?>;
      } else if (T == double) {
        storedValue =
            EnhancedPreferencesPlatform.instance.getDouble(
                  key,
                  opts.enableEncryption,
                )
                as Future<T?>;
      } else if (T == bool) {
        storedValue =
            EnhancedPreferencesPlatform.instance.getBool(
                  key,
                  opts.enableEncryption,
                )
                as Future<T?>;
      } else {
        throw TypeError();
      }

      if (opts.enableCache) {
        return storedValue.then((T? value) {
          cache[key] = value;
          return value;
        });
      } else {
        return storedValue;
      }
    }
  }

  /// Set item.
  @visibleForTesting
  Future<String?> setItem<T>(
    String key,
    T value, [
    EnhancedPreferencesOptions? options,
  ]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    Future<String?> storedKey;

    if (T == String) {
      storedKey = EnhancedPreferencesPlatform.instance.setString(
        key,
        value as String,
        opts.enableEncryption,
      );
    } else if (T == int) {
      storedKey = EnhancedPreferencesPlatform.instance.setInt(
        key,
        value as int,
        opts.enableEncryption,
      );
    } else if (T == double) {
      storedKey = EnhancedPreferencesPlatform.instance.setDouble(
        key,
        value as double,
        opts.enableEncryption,
      );
    } else if (T == bool) {
      storedKey = EnhancedPreferencesPlatform.instance.setBool(
        key,
        value as bool,
        opts.enableEncryption,
      );
    } else {
      throw TypeError();
    }

    if (opts.enableCache) {
      return storedKey.then((String? key) {
        if (key != null) {
          cache[key] = value;
        }
        return key;
      });
    } else {
      return storedKey;
    }
  }
}
