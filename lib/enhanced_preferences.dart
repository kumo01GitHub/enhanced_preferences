
import 'enhanced_preferences_platform_interface.dart';

class EnhancedPreferences {
  Future<String?> getString(String key) {
    return EnhancedPreferencesPlatform.instance.getString(key);
  }

  Future<String?> setString(String key, String value) {
    return EnhancedPreferencesPlatform.instance.setString(key, value);
  }

  Future<int?> getInt(String key) {
    return EnhancedPreferencesPlatform.instance.getInt(key);
  }

  Future<String?> setInt(String key, int value) {
    return EnhancedPreferencesPlatform.instance.setInt(key, value);
  }

  Future<double?> getDouble(String key) {
    return EnhancedPreferencesPlatform.instance.getDouble(key);
  }

  Future<String?> setDouble(String key, double value) {
    return EnhancedPreferencesPlatform.instance.setDouble(key, value);
  }

  Future<bool?> getBool(String key) {
    return EnhancedPreferencesPlatform.instance.getBool(key);
  }

  Future<String?> setBool(String key, bool value) {
    return EnhancedPreferencesPlatform.instance.setBool(key, value);
  }
}
