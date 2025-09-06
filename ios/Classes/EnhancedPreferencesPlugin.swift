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
    case "getString":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
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
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try setString(key: args["key"] as? String, value: args["value"] as? String))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "getInt":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try getInt(key: args["key"] as? String))
      } catch let error as EnhancedPreferencesError {
          result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "setInt":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try setInt(key: args["key"] as? String, value: args["value"] as? Int))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "getDouble":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try getDouble(key: args["key"] as? String))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "setDouble":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try setDouble(key: args["key"] as? String, value: args["value"] as? Double))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "getBool":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try getBool(key: args["key"] as? String))
      } catch let error as EnhancedPreferencesError {
        result(FlutterError(code: error.code, message: error.localizedDescription, details: nil))
      } catch let error {
        let e = EnhancedPreferencesError.unknownError(message: error.localizedDescription)
        result(FlutterError(code: e.code, message: e.localizedDescription, details: nil))
      }
    case "setBool":
      do {
        guard let args = call.arguments as? Dictionary<String, Any?> else {
          throw EnhancedPreferencesError.invalidArgument(message: "Invalid arguments.")
        }
        result(try setBool(key: args["key"] as? String, value: args["value"] as? Bool))
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
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }

    guard let value = UserDefaults.standard.string(forKey: key) else {
      throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil.")
    }

    return value
  }

  private func setString(key: String?, value: String?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }
    guard let value = value else {
      throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
    }

    UserDefaults.standard.set(value, forKey: key)

    return key
  }

  private func getInt(key: String?) throws -> Int {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }

    guard let value = UserDefaults.standard.object(forKey: key) as? Int else {
      throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil or not Int.")
    }

    return value
  }

  private func setInt(key: String?, value: Int?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }
    guard let value = value else {
      throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
    }

    UserDefaults.standard.set(value, forKey: key)

    return key
  }

  private func getDouble(key: String?) throws -> Double {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }

    guard let value = UserDefaults.standard.object(forKey: key) as? Double else {
      throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil or not Double.")
    }

    return value
  }

  private func setDouble(key: String?, value: Double?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }
    guard let value = value else {
      throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
    }

    UserDefaults.standard.set(value, forKey: key)

    return key
  }

  private func getBool(key: String?) throws -> Bool {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }

    guard let value = UserDefaults.standard.object(forKey: key) as? Bool else {
      throw EnhancedPreferencesError.referenceError(message: "Value for '\(key)' is nil or not Bool.")
    }

    return value
  }

  private func setBool(key: String?, value: Bool?) throws -> String {
    guard let key = key else {
      throw EnhancedPreferencesError.invalidArgument(message: "Key is nil.")
    }
    guard let value = value else {
      throw EnhancedPreferencesError.invalidArgument(message: "Value is nil.")
    }

    UserDefaults.standard.set(value, forKey: key)

    return key
  }
}
