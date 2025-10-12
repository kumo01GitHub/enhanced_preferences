#if os(macOS)
import FlutterMacOS
#else
import Flutter
#endif
import OSLog

public class EnhancedPreferencesPlugin: NSObject, FlutterPlugin {
    let log = OSLog(subsystem: "enhanced_preferences", category: "EnhancedPreferencesPlugin")

    public static func register(with registrar: FlutterPluginRegistrar) {
        #if os(macOS)
        let messenger = registrar.messenger
        #else
        let messenger = registrar.messenger()
        #endif
        let channel = FlutterMethodChannel(
            name: "enhanced_preferences", binaryMessenger: messenger)
        let instance = EnhancedPreferencesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        os_log("%@", log: log, type: .debug, call.method)

        do {
            switch call.method {
            case "getString":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(try UserDefaultsHandler.getEncryptedString(key: args["key"] as? String))
                } else {
                    result(try UserDefaultsHandler.getString(key: args["key"] as? String))
                }
            case "setString":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(
                        try UserDefaultsHandler.setEncryptedString(
                            key: args["key"] as? String, value: args["value"] as? String))
                } else {
                    result(
                        try UserDefaultsHandler.setString(
                            key: args["key"] as? String, value: args["value"] as? String))
                }
            case "getInt":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(try UserDefaultsHandler.getEncryptedInt(key: args["key"] as? String))
                } else {
                    result(try UserDefaultsHandler.getInt(key: args["key"] as? String))
                }
            case "setInt":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(
                        try UserDefaultsHandler.setEncryptedInt(
                            key: args["key"] as? String, value: args["value"] as? Int))
                } else {
                    result(
                        try UserDefaultsHandler.setInt(
                            key: args["key"] as? String, value: args["value"] as? Int))
                }
            case "getDouble":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(try UserDefaultsHandler.getEncryptedDouble(key: args["key"] as? String))
                } else {
                    result(try UserDefaultsHandler.getDouble(key: args["key"] as? String))
                }
            case "setDouble":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(
                        try UserDefaultsHandler.setEncryptedDouble(
                            key: args["key"] as? String, value: args["value"] as? Double))
                } else {
                    result(
                        try UserDefaultsHandler.setDouble(
                            key: args["key"] as? String, value: args["value"] as? Double))
                }
            case "getBool":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(try UserDefaultsHandler.getEncryptedBool(key: args["key"] as? String))
                } else {
                    result(try UserDefaultsHandler.getBool(key: args["key"] as? String))
                }
            case "setBool":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                if args["enableEncryption"] as? Bool == true {
                    result(
                        try UserDefaultsHandler.setEncryptedBool(
                            key: args["key"] as? String, value: args["value"] as? Bool))
                } else {
                    result(
                        try UserDefaultsHandler.setBool(
                            key: args["key"] as? String, value: args["value"] as? Bool))
                }
            case "remove":
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.remove(key: args["key"] as? String))
            case "keys":
                result(try UserDefaultsHandler.keys())
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch let error as EnhancedPreferencesError {
            result(
                FlutterError(
                    code: error.code, message: error.localizedDescription, details: nil))
        } catch let error {
            let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
            result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
        }
    }
}
