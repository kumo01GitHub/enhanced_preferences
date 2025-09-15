public class UserDefaultsHandler {
    private static func getInstance() -> UserDefaults {
        return UserDefaults.standard
    }

    public static func getString(key: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }
        guard let stringData = String(data: value, encoding: .utf8) else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key)' is not a string.")
        }

        return stringData
    }

    public static func setString(key: String?, value: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        UserDefaultsHandler.getInstance().set(value.data(using: .utf8), forKey: key)

        return key
    }

    public static func getInt(key: String?) throws -> Int {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        return value.withUnsafeBytes({ $0.load(as: Int.self) })
    }

    public static func setInt(key: String?, value: Int?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        UserDefaultsHandler.getInstance().set(
            Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), forKey: key)

        return key
    }

    public static func getDouble(key: String?) throws -> Double {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        return value.withUnsafeBytes({ $0.load(as: Double.self) })
    }

    public static func setDouble(key: String?, value: Double?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        UserDefaultsHandler.getInstance().set(
            Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), forKey: key)

        return key
    }

    public static func getBool(key: String?) throws -> Bool {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        return value.withUnsafeBytes({ $0.load(as: Bool.self) })
    }

    public static func setBool(key: String?, value: Bool?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        UserDefaultsHandler.getInstance().set(
            Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), forKey: key)

        return key
    }

    public static func getEncryptedString(key: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        var decrypted: Data? = nil
        do {
            decrypted = try CryptoHandler.decrypt(encrypted: value)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        guard let stringData = String(data: decrypted!, encoding: .utf8) else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key)' is not a string.")
        }

        return stringData
    }

    public static func setEncryptedString(key: String?, value: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        do {
            try UserDefaultsHandler.getInstance().set(
                CryptoHandler.encrypt(plain: value.data(using: .utf8)!), forKey: key)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        return key
    }

    public static func getEncryptedInt(key: String?) throws -> Int {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        var decrypted: Data? = nil
        do {
            decrypted = try CryptoHandler.decrypt(encrypted: value)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        // TODO: Fix faital error when value size is not invalid
        return decrypted!.withUnsafeBytes({ $0.load(as: Int.self) })
    }

    public static func setEncryptedInt(key: String?, value: Int?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        do {
            UserDefaultsHandler.getInstance().set(
                try CryptoHandler.encrypt(
                    plain: Data(bytes: &value, count: MemoryLayout.size(ofValue: value))),
                forKey: key)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        return key
    }

    public static func getEncryptedDouble(key: String?) throws -> Double {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        var decrypted: Data? = nil
        do {
            decrypted = try CryptoHandler.decrypt(encrypted: value)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        // TODO: Fix faital error when value size is not invalid
        return decrypted!.withUnsafeBytes({ $0.load(as: Double.self) })
    }

    public static func setEncryptedDouble(key: String?, value: Double?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        do {
            UserDefaultsHandler.getInstance().set(
                try CryptoHandler.encrypt(
                    plain: Data(bytes: &value, count: MemoryLayout.size(ofValue: value))),
                forKey: key)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        return key
    }

    public static func getEncryptedBool(key: String?) throws -> Bool {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        guard let value = UserDefaultsHandler.getInstance().data(forKey: key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        var decrypted: Data? = nil
        do {
            decrypted = try CryptoHandler.decrypt(encrypted: value)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

        // TODO: Fix faital error when value size is not invalid
        return decrypted!.withUnsafeBytes({ $0.load(as: Bool.self) })
    }

    public static func setEncryptedBool(key: String?, value: Bool?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        guard var value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        // TODO: Fix faital error when value size is not invalid
        do {
            UserDefaultsHandler.getInstance().set(
                try CryptoHandler.encrypt(
                    plain: Data(bytes: &value, count: MemoryLayout.size(ofValue: value))),
                forKey: key)
        } catch {
            throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
        }

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
