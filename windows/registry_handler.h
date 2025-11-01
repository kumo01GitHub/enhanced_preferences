#ifndef REGISTRY_HANDLER_H_
#define REGISTRY_HANDLER_H_

#include <string>
#include <optional>
#include <windows.h>

using namespace std;

namespace enhanced_preferences {

class RegistryHandler {
public:
  static optional<string> GetString(
    const string key
  );
  static optional<string> SetString(
    const string key,
    const string value
  );

 private:
  static optional<HKEY*> Open();
  static void Close(optional<HKEY*> hKey);
  static optional<string> GetItem(optional<string> key);
  static optional<string> SetItem(
    optional<string> key,
    optional<string> value
  );
};

}  // namespace enhanced_preferences

#endif  // REGISTRY_HANDLER_H_
