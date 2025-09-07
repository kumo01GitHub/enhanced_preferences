public class UserDefaultsHandler {
    private static func getInstance() -> UserDefaults {
        return UserDefaults.standard
    }

    public static func getString(key: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().string(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        return value
    }

    public static func setString(key: String?, value: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        UserDefaultsHandler.getInstance().set(value, forKey: key)

        return key
    }

    public static func getInt(key: String?) throws -> Int {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().object(forKey: key) as? Int else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key)' is nil or not Int.")
        }

        return value
    }

    public static func setInt(key: String?, value: Int?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        UserDefaultsHandler.getInstance().set(value, forKey: key)

        return key
    }

    public static func getDouble(key: String?) throws -> Double {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().object(forKey: key) as? Double else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key)' is nil or not Double.")
        }

        return value
    }

    public static func setDouble(key: String?, value: Double?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        UserDefaultsHandler.getInstance().set(value, forKey: key)

        return key
    }

    public static func getBool(key: String?) throws -> Bool {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().object(forKey: key) as? Bool else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key)' is nil or not Bool.")
        }

        return value
    }

    public static func setBool(key: String?, value: Bool?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        UserDefaultsHandler.getInstance().set(value, forKey: key)

        return key
    }

    public static func remove(key: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        UserDefaultsHandler.getInstance().removeObject(forKey: key)

        return key
    }
}
