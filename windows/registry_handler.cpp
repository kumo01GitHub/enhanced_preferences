#include "registry_handler.h"
#include "enhanced_preferences_exception.h"

#include <windows.h>
#include <psapi.h>

using namespace std;

namespace enhanced_preferences {
  void RegistryHandler::Initialize() {
    DWORD dwProcessId = GetCurrentProcessId();
    HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwProcessId);
    if (NULL != hProcess) {
      char baseName[MAX_PATH + 1];
      GetModuleBaseNameA(hProcess, NULL, baseName, sizeof(baseName));
      RegistryHandler::subKey = baseName;
      RegistryHandler::subKey += RegistryHandler::subKeySuffix;
      CloseHandle(hProcess);
    }
  }

  string RegistryHandler::GetString(
    const string *key
  ) {
    const string result = GetItem(key);
    return result;
  }

  string RegistryHandler::SetString(
    const string *key,
    const string *value
  ) {
    return SetItem(key, value);
  }

  int RegistryHandler::GetInt(
    const string *key
  ) {
    const string result = GetItem(key);
    return stoi(result);
  }

  string RegistryHandler::SetInt(
    const string *key,
    const int *value
  ) {
    const string val = to_string(*value);
    return SetItem(key, &val);
  }

  double RegistryHandler::GetDouble(
    const string *key
  ) {
    const string result = GetItem(key);
    return stod(result);
  }

  string RegistryHandler::SetDouble(
    const string *key,
    const double *value
  ) {
    const string val = to_string(*value);
    return SetItem(key, &val);
  }

  bool RegistryHandler::GetBool(
    const string *key
  ) {
    const string result = GetItem(key);
    return result.compare("false");
  }

  string RegistryHandler::SetBool(
    const string *key,
    const bool *value
  ) {
    const string val = *value ? "true" : "false";
    return SetItem(key, &val);
  }

  string RegistryHandler::Remove(
    const string *key
  ) {
    return RemoveItem(key);
  }

  vector<string> RegistryHandler::Keys() {
    const HKEY hKey = Open();

    DWORD index = 0;
    DWORD result;
    vector<string> keys;

    do {
      char valueName[MAX_PATH + 1];
      DWORD valueNameSize = MAX_PATH;

      result = RegEnumValueA(
        hKey,
        index,
        valueName,
        &valueNameSize,
        NULL, NULL, NULL, NULL
      );

      if (result == ERROR_SUCCESS) {
        keys.push_back(valueName);
        index++;
      } else if (result != ERROR_NO_MORE_ITEMS) {
        throw EnhancedPreferencesException(
          REFERENCE_ERROR, "Could not get key. [" + to_string(result) + "]");
      }
    } while (result == ERROR_SUCCESS);

    return keys;
  }

  HKEY RegistryHandler::Open() {
    HKEY hKey;
    DWORD dwDisposition;

    LONG lResult = RegCreateKeyExA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      0,
      NULL,
      REG_OPTION_NON_VOLATILE,
      KEY_ALL_ACCESS,
      NULL,
      &hKey,
      &dwDisposition
    );

    if (lResult == ERROR_SUCCESS) {
      return hKey;
    } else {
      throw EnhancedPreferencesException(
        REFERENCE_ERROR, "Could not open Windows Registry. [" + to_string(lResult) + "]");
    }
  }

  void RegistryHandler::Close(HKEY* hKey) {
    if (hKey) {
      RegCloseKey(*hKey);
    }
  }

  string RegistryHandler::GetItem(const string *key) {
    if (!key) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is null.");
    } else if (key->empty()) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is empty.");
    }

    DWORD dataSize{};
    LONG lResult = RegGetValueA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      (*key).c_str(),
      RRF_RT_REG_SZ,
      NULL,
      NULL,
      &dataSize
    );

    if (lResult != ERROR_SUCCESS) {
      throw EnhancedPreferencesException(
        REFERENCE_ERROR, "Could not access sub key: " + *key + ". [" + to_string(lResult) + "]");
    }

    string data;
    data.resize(dataSize / sizeof(char));

    lResult = RegGetValueA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      (*key).c_str(),
      RRF_RT_REG_SZ,
      NULL,
      &data,
      &dataSize
    );

    if (lResult == ERROR_SUCCESS) {
      return data.c_str();
    } else {
      throw EnhancedPreferencesException(
        REFERENCE_ERROR, "Could not get value for sub key " + *key + ". [" + to_string(lResult) + "]");
    }
  }

  string RegistryHandler::SetItem(
    const string *key,
    const string *value
  ) {
    if (!key) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is null.");
    } else if (key->empty()) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is empty.");
    }

    if (!value) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Value is null.");
    } else if (value->empty()) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Value is empty.");
    }

    HKEY hKey = Open();
    LONG lResult = RegSetValueExA(
      hKey,
      (*key).c_str(),
      0,
      REG_SZ,
      (LPBYTE)(*value).c_str(),
      (DWORD)(*value).size() * sizeof(char)
    );

    Close(&hKey);

    if (lResult == ERROR_SUCCESS) {
      return (*key);
    } else {
    throw EnhancedPreferencesException(
      REFERENCE_ERROR, "Could not set value for sub key: " + *key + ". [" + to_string(lResult) + "]");
    }
  }

  string RegistryHandler::RemoveItem(const string *key) {
    if (!key) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is null.");
    } else if (key->empty()) {
      throw EnhancedPreferencesException(REFERENCE_ERROR, "Key is empty.");
    }

    HKEY hKey = Open();
    LONG lResult = RegDeleteValueA(
      hKey,
      (*key).c_str()
    );

    Close(&hKey);

    if (lResult == ERROR_SUCCESS) {
      return (*key);
    } else {
      throw EnhancedPreferencesException(
        REFERENCE_ERROR, "Could not remove sub key: " + *key + ". [" + to_string(lResult) + "]");
    }
  }
}  // namespace enhanced_preferences
