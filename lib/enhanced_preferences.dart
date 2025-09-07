import 'enhanced_preferences_platform_interface.dart';

class EnhancedPreferencesOptions {
  final bool enableCache;

  const EnhancedPreferencesOptions({ this.enableCache = true });
}

class EnhancedPreferences {
  final Map<String, dynamic> _cache = {};

  Future<String?> getString(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as String?);
    } else {
      return EnhancedPreferencesPlatform.instance.getString(key)
        .then((String? value) {
          if (opts.enableCache) {
            _cache[key] = value;
          }
          return value;
        });
    }
  }

  Future<String?> setString(String key, String value, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance.setString(key, value)
      .then((String? key) {
        if (opts.enableCache && key != null) {
          _cache[key] = value;
        }
        return key;
      });
  }

  Future<int?> getInt(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as int?);
    } else {
      return EnhancedPreferencesPlatform.instance.getInt(key)
        .then((int? value) {
          if (opts.enableCache) {
            _cache[key] = value;
          }
          return value;
        });
    }
  }

  Future<String?> setInt(String key, int value, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance.setInt(key, value)
      .then((String? key) {
        if (opts.enableCache && key != null) {
          _cache[key] = value;
        }
        return key;
      });
  }

  Future<double?> getDouble(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as double?);
    } else {
      return EnhancedPreferencesPlatform.instance.getDouble(key)
        .then((double? value) {
          if (opts.enableCache) {
            _cache[key] = value;
          }
          return value;
        });
    }
  }

  Future<String?> setDouble(String key, double value, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance.setDouble(key, value)
      .then((String? key) {
        if (opts.enableCache && key != null) {
          _cache[key] = value;
        }
        return key;
      });
  }

  Future<bool?> getBool(String key, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    if (opts.enableCache && _cache.containsKey(key)) {
      return Future.value(_cache[key] as bool?);
    } else {
      return EnhancedPreferencesPlatform.instance.getBool(key)
        .then((bool? value) {
          if (opts.enableCache) {
            _cache[key] = value;
          }
          return value;
        });
    }
  }

  Future<String?> setBool(String key, bool value, [EnhancedPreferencesOptions? options]) {
    final EnhancedPreferencesOptions opts = options ?? EnhancedPreferencesOptions();

    return EnhancedPreferencesPlatform.instance.setBool(key, value)
      .then((String? key) {
        if (opts.enableCache && key != null) {
          _cache[key] = value;
        }
        return key;
      });
  }
}
