import 'enhanced_preferences_platform_interface.dart';

class EnhancedPreferencesOptions {
  final bool enableCache;
  final bool enableEncryption;

  // TODO: Fix default values
  const EnhancedPreferencesOptions({
    this.enableCache = false,
    this.enableEncryption = true,
  });
}

class EnhancedPreferences {
  final Map<String, dynamic> _cache = {};

  Future<String?> getString(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as String?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getString(key, opts.enableEncryption)
          .then((String? value) {
            if (opts.enableCache) {
              _cache[key] = value;
            }
            return value;
          });
    }
  }

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
            _cache[key] = value;
          }
          return key;
        });
  }

  Future<int?> getInt(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as int?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getInt(key, opts.enableEncryption)
          .then((int? value) {
            if (opts.enableCache) {
              _cache[key] = value;
            }
            return value;
          });
    }
  }

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
            _cache[key] = value;
          }
          return key;
        });
  }

  Future<double?> getDouble(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as double?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getDouble(key, opts.enableEncryption)
          .then((double? value) {
            if (opts.enableCache) {
              _cache[key] = value;
            }
            return value;
          });
    }
  }

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
            _cache[key] = value;
          }
          return key;
        });
  }

  Future<bool?> getBool(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts =
        options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as bool?);
    } else {
      return EnhancedPreferencesPlatform.instance
          .getBool(key, opts.enableEncryption)
          .then((bool? value) {
            if (opts.enableCache) {
              _cache[key] = value;
            }
            return value;
          });
    }
  }

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
            _cache[key] = value;
          }
          return key;
        });
  }

  Future<String?> remove(String key) {
    return EnhancedPreferencesPlatform.instance.remove(key).then((String? key) {
      _cache.remove(key);
      return key;
    });
  }
}
