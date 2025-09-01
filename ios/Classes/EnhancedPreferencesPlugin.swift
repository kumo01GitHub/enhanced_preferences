import Flutter
import UIKit

public class EnhancedPreferencesPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "enhanced_preferences", binaryMessenger: registrar.messenger())
    let instance = EnhancedPreferencesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getString":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments")
        }
        result(try getString(key: args["key"] as? String))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "setString":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments")
        }
        result(try setString(key: args["key"] as? String, value: args["value"] as? String))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getString(key: String?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil")
    }

    guard let value = UserDefaults.standard.string(forKey: key) else {
      throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil")
    }

    return value
  }

  private func setString(key: String?, value: String?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil")
    }
    guard let value = value else {
      throw EnhancedPreferencesError.invalidArgument(message: "Value is nil")
    }

    UserDefaults.standard.set(value, forKey: key)

    return key
  }
}
