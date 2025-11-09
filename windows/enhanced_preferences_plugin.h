#ifndef FLUTTER_PLUGIN_ENHANCED_PREFERENCES_PLUGIN_H_
#define FLUTTER_PLUGIN_ENHANCED_PREFERENCES_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

using namespace std;

namespace enhanced_preferences {

class EnhancedPreferencesPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EnhancedPreferencesPlugin();

  virtual ~EnhancedPreferencesPlugin();

  // Disallow copy and assign.
  EnhancedPreferencesPlugin(const EnhancedPreferencesPlugin&) = delete;
  EnhancedPreferencesPlugin& operator=(const EnhancedPreferencesPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace enhanced_preferences

#endif  // FLUTTER_PLUGIN_ENHANCED_PREFERENCES_PLUGIN_H_
