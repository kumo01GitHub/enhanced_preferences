#include "enhanced_preferences_exception.h"

using namespace std;

namespace enhanced_preferences {
  EnhancedPreferencesException::EnhancedPreferencesException(
    const ErrorCode &code, const string &msg) {
    errCode = code;
    errMsg = msg;
  };

  char const *EnhancedPreferencesException::what() const noexcept {
    return errMsg.c_str();
  };

  string EnhancedPreferencesException::code() {
    string code;

    switch(errCode) {
      case INVALID_ARGUMENT:
        code = "INVALID_ARGUMENT";
        break;
      case REFERENCE_ERROR:
        code = "REFERENCE_ERROR";
        break;
      case ILLEGAL_ACCESS:
        code = "ILLEGAL_ACCESS";
        break;
      default:
        code = "UNKNOWN_ERROR";
        break;
    }

    return code;
  }
}  // namespace enhanced_preferences
