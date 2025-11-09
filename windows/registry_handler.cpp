#include "registry_handler.h"

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

  optional<string> RegistryHandler::GetString(
    const string key
  ) {
    const optional<string> result = GetItem(key);
    return result;
  }

  optional<string> RegistryHandler::SetString(
    const string key,
    const string value
  ) {
    const optional<string> result = SetItem(key, value);
    return result;
  }

  optional<string> RegistryHandler::Remove(
    const string key
  ) {
    const optional<string> result = RemoveItem(key);
    return result;
  }

  vector<string> RegistryHandler::Keys() {
    const optional<HKEY*> hKey = Open();

    if (hKey)  {
      DWORD index = 0;
      DWORD result;
      vector<string> keys;

      do {
        char valueName[MAX_PATH + 1];
        DWORD valueNameSize = MAX_PATH;

        result = RegEnumValueA(
          *hKey.value(),
          index,
          valueName,
          &valueNameSize,
          NULL, NULL, NULL, NULL
        );

        if (result == ERROR_SUCCESS) {
          keys.push_back(valueName);
          index++;
        }
      } while (result == ERROR_SUCCESS);

      return keys;
    } else {
      return {};
    }
  }

  optional<HKEY*> RegistryHandler::Open() {
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
      return &hKey;
    } else {
      return nullopt;
    }
  }

  void RegistryHandler::Close(optional<HKEY*> hKey) {
    if (hKey) {     
      RegCloseKey(*hKey.value());
    }
  }

  optional<string> RegistryHandler::GetItem(const string key) {
    DWORD dataSize{};
    LONG lResult = RegGetValueA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      key.c_str(),
      RRF_RT_REG_SZ,
      NULL,
      NULL,
      &dataSize
    );

    if (lResult != ERROR_SUCCESS) {
      return nullopt;
    }

    string data;
    data.resize(dataSize / sizeof(char));

    lResult = RegGetValueA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      key.c_str(),
      RRF_RT_REG_SZ,
      NULL,
      &data,
      &dataSize
    );

    if (lResult == ERROR_SUCCESS) {
      return data.c_str();
    } else {
      return nullopt;
    }
  }

  optional<string> RegistryHandler::SetItem(
    const string key,
    const string value
  ) {
    const optional<HKEY*> hKey = Open();
    if (hKey) {
      LONG lResult = RegSetValueExA(
        *hKey.value(),
        key.c_str(),
        0,
        REG_SZ,
        (LPBYTE)value.c_str(),
        (DWORD)value.size() * sizeof(char)
      );

      Close(hKey);

      if (lResult == ERROR_SUCCESS) {
        return key;
      } else {
        return nullopt;
      }
    } else {
      return nullopt;
    }
  }

  optional<string> RegistryHandler::RemoveItem(const string key) {
    const optional<HKEY*> hKey = Open();
    if (hKey) {
      LONG lResult = RegDeleteValueA(
        *hKey.value(),
        key.c_str()
      );

      Close(hKey);

      if (lResult == ERROR_SUCCESS) {
        return key;
      } else {
        return nullopt;
      }
    } else {
      return nullopt;
    }
  }
}  // namespace enhanced_preferences
