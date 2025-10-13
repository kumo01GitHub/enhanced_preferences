#include "include/enhanced_preferences/enhanced_preferences_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "enhanced_preferences_plugin.h"

void EnhancedPreferencesPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  enhanced_preferences::EnhancedPreferencesPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
