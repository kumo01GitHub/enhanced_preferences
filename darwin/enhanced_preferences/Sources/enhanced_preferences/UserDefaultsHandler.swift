import Foundation

public class UserDefaultsHandler {
    private static let keyPrefix = "FEP@"

    private static func getInstance() -> UserDefaults {
        return UserDefaults.standard
    }

    private static func getItem(key: String?, type: EnhancedPreferencesType, enableEncryption: Bool) throws -> Data {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        if (key.isEmpty) {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is empty.")
        }

        guard let value = UserDefaultsHandler.getInstance().string(forKey: keyPrefix + key) else {
            throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
        }

        if (enableEncryption) {
            let regex = try NSRegularExpression(pattern: "^\(type):[A-Za-z0-9+/=]+:[A-Za-z0-9+/=]+$")
            if (regex.matches(in: value, range: NSRange(0..<value.utf16.count)).count == 0) {
                throw EnhancedPreferencesError.referenceError(message: "Invalid value.")
            }
            let components = value.components(separatedBy: ":")
            guard let data = Data(base64Encoded: components[1]) else {
                throw EnhancedPreferencesError.referenceError(message: "Invalid value.")
            }
            guard let dataKey = Data(base64Encoded: components[2]) else {
                throw EnhancedPreferencesError.referenceError(message: "Invalid value.")
            }

            return try CryptoHandler.decrypt(cipherData: CipherData(data: data, key: dataKey))!
        } else {
            let regex = try NSRegularExpression(pattern: "^\(type):[A-Za-z0-9+/=]+$")
            if (regex.matches(in: value, range: NSRange(0..<value.utf16.count)).count == 0) {
                throw EnhancedPreferencesError.referenceError(message: "Invalid value.")
            }

            return Data(base64Encoded: value.components(separatedBy: ":")[1])!
        }
    }
    
    private static func setItem(key: String?, value: Data?, type: EnhancedPreferencesType, enableEncryption: Bool) throws {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }
        if (key.isEmpty) {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is empty.")
        }
        guard let value = value else {
            throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
        }

        if (enableEncryption) {
            do {
                let cipherData = try CryptoHandler.encrypt(plainText: value)
                UserDefaultsHandler.getInstance().set("\(type):\(cipherData.data.base64EncodedString()):\(cipherData.key.base64EncodedString())", forKey: keyPrefix + key)
            } catch {
                throw EnhancedPreferencesError.illegalAccess(message: error.localizedDescription)
            }
        } else {
            UserDefaultsHandler.getInstance().set("\(type):\(value.base64EncodedString())", forKey: keyPrefix + key)
        }
    }

    public static func getString(key: String?) throws -> String {
        let data = try getItem(key: key, type: EnhancedPreferencesType.string, enableEncryption: false)
        guard let value = String(data: data, encoding: .utf8) else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key!)' is not a string.")
        }

        return value
    }

    public static func setString(key: String?, value: String?) throws -> String {
        try setItem(key: key, value: value?.data(using: .utf8), type: EnhancedPreferencesType.string, enableEncryption: false)

        return key!
    }

    public static func getInt(key: String?) throws -> Int {
        let data = try getItem(key: key, type: EnhancedPreferencesType.int, enableEncryption: false)

        return data.withUnsafeBytes({ $0.load(as: Int.self) })
    }

    public static func setInt(key: String?, value: Int?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.int, enableEncryption: false)

        return key!
    }

    public static func getDouble(key: String?) throws -> Double {
        let data = try getItem(key: key, type: EnhancedPreferencesType.double, enableEncryption: false)

        return data.withUnsafeBytes({ $0.load(as: Double.self) })
    }

    public static func setDouble(key: String?, value: Double?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.double, enableEncryption: false)

        return key!
    }

    public static func getBool(key: String?) throws -> Bool {
        let data = try getItem(key: key, type: EnhancedPreferencesType.bool, enableEncryption: false)

        return data.withUnsafeBytes({ $0.load(as: Bool.self) })
    }

    public static func setBool(key: String?, value: Bool?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.bool, enableEncryption: false)

        return key!
    }

    public static func getEncryptedString(key: String?) throws -> String {
        let data = try getItem(key: key, type: EnhancedPreferencesType.string, enableEncryption: true)
        guard let value = String(data: data, encoding: .utf8) else {
            throw EnhancedPreferencesError.referenceError(
                message: "Value for '\(key!)' is not a string.")
        }

        return value
    }
    
    public static func setEncryptedString(key: String?, value: String?) throws -> String {
        try setItem(key: key, value: value?.data(using: .utf8), type: EnhancedPreferencesType.string, enableEncryption: true)

        return key!
    }

    public static func getEncryptedInt(key: String?) throws -> Int {
        let data = try getItem(key: key, type: EnhancedPreferencesType.int, enableEncryption: true)

        return data.withUnsafeBytes({ $0.load(as: Int.self) })
    }

    public static func setEncryptedInt(key: String?, value: Int?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.int, enableEncryption: true)

        return key!
    }

    public static func getEncryptedDouble(key: String?) throws -> Double {
        let data = try getItem(key: key, type: EnhancedPreferencesType.double, enableEncryption: true)

        return data.withUnsafeBytes({ $0.load(as: Double.self) })
    }

    public static func setEncryptedDouble(key: String?, value: Double?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.double, enableEncryption: true)

        return key!
    }

    public static func getEncryptedBool(key: String?) throws -> Bool {
        let data = try getItem(key: key, type: EnhancedPreferencesType.bool, enableEncryption: true)

        return data.withUnsafeBytes({ $0.load(as: Bool.self) })
    }

    public static func setEncryptedBool(key: String?, value: Bool?) throws -> String {
        var value = value
        try setItem(key: key, value: Data(bytes: &value, count: MemoryLayout.size(ofValue: value)), type: EnhancedPreferencesType.bool, enableEncryption: true)

        return key!
    }

    public static func remove(key: String?) throws -> String {
        guard let key = key else {
            throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
        }

        UserDefaultsHandler.getInstance().removeObject(forKey: keyPrefix + key)

        return key
    }

    public static func keys() throws -> [String] {
        var keys: [String] = []
        for key in UserDefaultsHandler.getInstance().dictionaryRepresentation().keys {
            if (key.hasPrefix(keyPrefix)) {
                keys.append(String(key.dropFirst(keyPrefix.count)))
            }
        }
        return keys
    }
}
