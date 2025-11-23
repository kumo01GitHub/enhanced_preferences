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
  static string GetString(
    const string *key
  );
  static string SetString(
    const string *key,
    const string *value
  );
  static int GetInt(
    const string *key
  );
  static string SetInt(
    const string *key,
    const int *value
  );
  static double GetDouble(
    const string *key
  );
  static string SetDouble(
    const string *key,
    const double *value
  );
  static bool GetBool(
    const string *key
  );
  static string SetBool(
    const string *key,
    const bool *value
  );
  static string Remove(
    const string *key
  );
  static vector<string> Keys();

 private:
  inline static string subKey;
  inline static const string subKeySuffix = "\\FEP";
  static HKEY Open();
  static void Close(HKEY* hKey);
  static string GetItem(const string *key);
  static string SetItem(
    const string *key,
    const string *value
  );
  static string RemoveItem(const string *key);
};

}  // namespace enhanced_preferences

#endif  // REGISTRY_HANDLER_H_
