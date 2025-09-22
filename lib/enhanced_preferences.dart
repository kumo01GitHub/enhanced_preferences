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

/// Cached preference type.
enum PrefCacheType { string, int, double, bool }

/// Chached preference item.
class PrefCacheItem {
  final PrefCacheType type;
  final dynamic value;

  PrefCacheItem(this.type, this.value);
}

/// A implementation of the EnhancedPreferencesPlatform.
class EnhancedPreferences {
  /// Cache.
  final Map<String, PrefCacheItem> _cache = {};

  /// Get the string value for the given key.
  Future<String?> getString(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache &&
        _cache.containsKey(key) &&
        _cache[key]?.type == PrefCacheType.string) {
      return Future.value(_cache[key]?.value as String?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getString(key, opts.enableEncryption)
          .then((String? value) {
            if (opts.enableCache) {
              _cache[key] = PrefCacheItem(PrefCacheType.string, value);
            }
            return value;
          });
    }
  }

  /// Set the string value for the given key.
  Future<String?> setString(
    String key,
    String value, [
    EnhancedPreferencesOptions? options,
  ]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance
        .setString(key, value, opts.enableEncryption)
        .then((String? key) {
          if (opts.enableCache && key != null) {
            _cache[key] = PrefCacheItem(PrefCacheType.string, value);
          }
          return key;
        });
  }

  /// Get the integer value for the given key.
  Future<int?> getInt(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache &&
        _cache.containsKey(key) &&
        _cache[key]?.type == PrefCacheType.int) {
      return Future.value(_cache[key]?.value as int?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getInt(key, opts.enableEncryption)
          .then((int? value) {
            if (opts.enableCache) {
              _cache[key] = PrefCacheItem(PrefCacheType.int, value);
            }
            return value;
          });
    }
  }

  /// Set the integer value for the given key.
  Future<String?> setInt(
    String key,
    int value, [
    EnhancedPreferencesOptions? options,
  ]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance
        .setInt(key, value, opts.enableEncryption)
        .then((String? key) {
          if (opts.enableCache && key != null) {
            _cache[key] = PrefCacheItem(PrefCacheType.int, value);
          }
          return key;
        });
  }

  /// Get the double value for the given key.
  Future<double?> getDouble(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache &&
        _cache.containsKey(key) &&
        _cache[key]?.type == PrefCacheType.double) {
      return Future.value(_cache[key]?.value as double?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getDouble(key, opts.enableEncryption)
          .then((double? value) {
            if (opts.enableCache) {
              _cache[key] = PrefCacheItem(PrefCacheType.double, value);
            }
            return value;
          });
    }
  }

  /// Set the double value for the given key.
  Future<String?> setDouble(
    String key,
    double value, [
    EnhancedPreferencesOptions? options,
  ]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance
        .setDouble(key, value, opts.enableEncryption)
        .then((String? key) {
          if (opts.enableCache && key != null) {
            _cache[key] = PrefCacheItem(PrefCacheType.double, value);
          }
          return key;
        });
  }

  /// Get the boolean value for the given key.
  Future<bool?> getBool(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache &&
        _cache.containsKey(key) &&
        _cache[key]?.type == PrefCacheType.bool) {
      return Future.value(_cache[key]?.value as bool?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getBool(key, opts.enableEncryption)
          .then((bool? value) {
            if (opts.enableCache) {
              _cache[key] = PrefCacheItem(PrefCacheType.bool, value);
            }
            return value;
          });
    }
  }

  /// Set the boolean value for the given key.
  Future<String?> setBool(
    String key,
    bool value, [
    EnhancedPreferencesOptions? options,
  ]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance
        .setBool(key, value, opts.enableEncryption)
        .then((String? key) {
          if (opts.enableCache && key != null) {
            _cache[key] = PrefCacheItem(PrefCacheType.bool, value);
          }
          return key;
        });
  }

  /// Remove the key.
  Future<String?> remove(String key) {
    return EnhancedPreferencesPlatform.instance.remove(key).then((String? key) {
      _cache.remove(key);
      return key;
    });
  }
}
