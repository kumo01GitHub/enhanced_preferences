
import 'enhanced_preferences_platform_interface.dart';

class EnhancedPreferences {
  Future<String?> getPlatformVersion() {
    return EnhancedPreferencesPlatform.instance.getPlatformVersion();
  }
}
