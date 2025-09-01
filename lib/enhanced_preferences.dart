
import 'enhanced_preferences_platform_interface.dart';

class EnhancedPreferences {
  Future<String?> getPlatformVersion() {
    return EnhancedPreferencesPlatform.instance.getPlatformVersion();
  }

  Future<String?> getString(String key) {
    return EnhancedPreferencesPlatform.instance.getString(key);
  }

  Future<String?> setString(String key, String value) {
    return EnhancedPreferencesPlatform.instance.setString(key, value);
  }
}
