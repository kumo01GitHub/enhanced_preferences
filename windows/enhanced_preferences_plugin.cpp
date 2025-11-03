#include "enhanced_preferences_plugin.h"
#include "registry_handler.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

using namespace std;

namespace enhanced_preferences {

// static
void EnhancedPreferencesPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "enhanced_preferences",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = make_unique<EnhancedPreferencesPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, move(result));
      });

  registrar->AddPlugin(move(plugin));
}

EnhancedPreferencesPlugin::EnhancedPreferencesPlugin() {}

EnhancedPreferencesPlugin::~EnhancedPreferencesPlugin() {}

void EnhancedPreferencesPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const string method = method_call.method_name();
  const flutter::EncodableMap *args = get_if<flutter::EncodableMap>(method_call.arguments());

  if (method.compare("getString") == 0) {
    const string key = get<string>(args->at(flutter::EncodableValue("key")));

    optional<string> res = RegistryHandler::GetString(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("setString") == 0) {
    const string key = get<string>(args->at(flutter::EncodableValue("key")));
    const string value = get<string>(args->at(flutter::EncodableValue("value")));

    optional<string> res = RegistryHandler::SetString(key, value);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else {
    result->NotImplemented();
  }
}

}  // namespace enhanced_preferences
