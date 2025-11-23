#ifndef ENHANCED_PREFERENCES_EXCEPTION_H_
#define ENHANCED_PREFERENCES_EXCEPTION_H_

#include <exception>
#include <string>

using namespace std;

namespace enhanced_preferences {

  enum ErrorCode {
    INVALID_ARGUMENT,
    REFERENCE_ERROR,
    ILLEGAL_ACCESS,
    UNKNOWN_ERROR
  };

class EnhancedPreferencesException : public exception {
public:
  EnhancedPreferencesException(const ErrorCode &code, const string &msg);
  virtual ~EnhancedPreferencesException();

  char const *what() const noexcept;
  string code();

  ErrorCode errCode;
  string errMsg;
};

}  // namespace enhanced_preferences

#endif  // ENHANCED_PREFERENCES_EXCEPTION_H_
