#include "enhanced_preferences_plugin.h"
#include "enhanced_preferences_exception.h"
#include "registry_handler.h"

// This must be included before many other Windows headers.
#include <windows.h>

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

EnhancedPreferencesPlugin::EnhancedPreferencesPlugin() {
  RegistryHandler::Initialize();
}

EnhancedPreferencesPlugin::~EnhancedPreferencesPlugin() {}

void EnhancedPreferencesPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const string method = method_call.method_name();
  const flutter::EncodableMap *args = get_if<flutter::EncodableMap>(method_call.arguments());

  if (method.compare("getString") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));

    optional<string> res = RegistryHandler::GetString(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("setString") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));
    const string *value = get_if<string>(&args->at(flutter::EncodableValue("value")));

    optional<string> res = RegistryHandler::SetString(key, value);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("getInt") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));

    optional<int> res = RegistryHandler::GetInt(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("setInt") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));
    const int *value = get_if<int>(&args->at(flutter::EncodableValue("value")));

    optional<string> res = RegistryHandler::SetInt(key, value);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("getDouble") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));

    optional<double> res = RegistryHandler::GetDouble(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("setDouble") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));
    const double *value = get_if<double>(&args->at(flutter::EncodableValue("value")));

    optional<string> res = RegistryHandler::SetDouble(key, value);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("getBool") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));

    optional<bool> res = RegistryHandler::GetBool(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("setBool") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));
    const bool *value = get_if<bool>(&args->at(flutter::EncodableValue("value")));

    optional<string> res = RegistryHandler::SetBool(key, value);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("remove") == 0) {
    const string *key = get_if<string>(&args->at(flutter::EncodableValue("key")));

    optional<string> res = RegistryHandler::Remove(key);
    if (res) {
      result->Success(flutter::EncodableValue(res.value()));
    } else {
      result->Error("UNKNOWN_ERROR", "Failure");
    }
  } else if (method.compare("keys") == 0) {
    const vector<string> keys = RegistryHandler::Keys();
    vector<flutter::EncodableValue> res;
    for (string key : keys) {
      res.push_back(flutter::EncodableValue(key));
    }
    result->Success(flutter::EncodableValue(res));
  } else {
    result->NotImplemented();
  }
}

}  // namespace enhanced_preferences
