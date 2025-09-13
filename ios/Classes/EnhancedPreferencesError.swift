import Foundation

enum EnhancedPreferencesError: Error, LocalizedError {
    case invalidArgument(message: String)
    case referenceError(message: String)
    case illegalAccess(message: String)
    case unknownError(message: String)

    var code: String {
        switch self {
        case .invalidArgument:
            return "INVALID_ARGUMENT"
        case .referenceError:
            return "REFERENCE_ERROR"
        case .illegalAccess:
            return "ILLEGAL_ACCESS"
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
        case .illegalAccess(let message):
            return message
        case .unknownError(let message):
            return message
        }
    }
}
