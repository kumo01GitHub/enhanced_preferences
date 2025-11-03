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

  optional<string> RegistryHandler::GetItem(optional<string> key) {
    if (!key) {
      return nullopt;
    }
    
    DWORD dataSize{};
    LONG lResult = RegGetValueA(
      HKEY_CURRENT_USER,
      RegistryHandler::subKey.c_str(),
      key.value().c_str(),
      RRF_RT_REG_SZ,
      nullptr,
      nullptr,
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
      key.value().c_str(),
      RRF_RT_REG_SZ,
      nullptr,
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
    optional<string> key,
    optional<string> value
  ) {
    if (!key || !value) {
      return nullopt;
    }

    const optional<HKEY*> hKey = Open();
    if (hKey) {
      LONG lResult = RegSetValueExA(
        *hKey.value(),
        key.value().c_str(),
        0,
        REG_SZ,
        (LPBYTE)value.value().c_str(),
        (DWORD)value.value().size() * sizeof(char)
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
