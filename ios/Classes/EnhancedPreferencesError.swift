import Foundation

enum EnhancedPreferencesError: Error, LocalizedError {
  case invalidArgument(message: String)
  case referenceError(message: String)
  case invalidAccess(message: String)
  case unknownError(message: String)
  
  var code: String {
    switch self {
    case .invalidArgument:
        return "INVALID_ARGUMENT"
    case .referenceError:
        return "REFERENCE_ERROR"
    case .invalidAccess:
        return "INVALID_ACCESS"
    case .unknownError:
        return "UNKNOWN_ERROR"
    }
  }

  var errorDescription: String? {
    switch self {
    case .invalidArgument(let message):
      return message
    case .referenceError(let message):
      return message
    case .invalidAccess(let message):
      return message
    case .unknownError(let message):
      return message
    }
  }
}
