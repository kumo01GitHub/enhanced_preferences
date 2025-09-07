import Flutter
import UIKit

public class EnhancedPreferencesPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "enhanced_preferences", binaryMessenger: registrar.messenger())
        let instance = EnhancedPreferencesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getString":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.getString(key: args["key"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "setString":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.setString(key: args["key"] as? String, value: args["value"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "getInt":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.getInt(key: args["key"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "setInt":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.setInt(key: args["key"] as? String, value: args["value"] as? Int))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "getDouble":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.getDouble(key: args["key"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "setDouble":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.setDouble(key: args["key"] as? String, value: args["value"] as? Double))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "getBool":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.getBool(key: args["key"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "setBool":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.setBool(key: args["key"] as? String, value: args["value"] as? Bool))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        case "remove":
            do {
                guard let args = call.arguments as? [String: Any?] else {
                    throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
                }
                result(try UserDefaultsHandler.remove(key: args["key"] as? String))
            } catch let error as EnhancedPreferencesError {
                result(
                    FlutterError(
                        code: error.code, message: error.localizedDescription, details: nil))
            } catch let error {
                let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
                result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
