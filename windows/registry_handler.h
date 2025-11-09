#ifndef REGISTRY_HANDLER_H_
#define REGISTRY_HANDLER_H_

#include <windows.h>
#include <optional>
#include <string>
#include <vector>

using namespace std;

namespace enhanced_preferences {

class RegistryHandler {
public:
  static void Initialize();
  static optional<string> GetString(
    const string key
  );
  static optional<string> SetString(
    const string key,
    const string value
  );
  static optional<string> Remove(
    const string key
  );
  static vector<string> Keys();

 private:
  inline static string subKey;
  inline static const string subKeySuffix = "\\FEP";
  static optional<HKEY*> Open();
  static void Close(optional<HKEY*> hKey);
  static optional<string> GetItem(const string key);
  static optional<string> SetItem(
    const string key,
    const string value
  );
  static optional<string> RemoveItem(const string key);
};

}  // namespace enhanced_preferences

#endif  // REGISTRY_HANDLER_H_
