import Flutter
import UIKit

public class FlutterSsoPlugin: NSObject, FlutterPlugin {
  private var keychainGroup: String?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.rpsmobile.sso/account", binaryMessenger: registrar.messenger())
    let instance = FlutterSsoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "configure":
      if let args = call.arguments as? [String: Any],
         let group = args["keychainGroup"] as? String {
        keychainGroup = group
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Keychain group missing", details: nil))
      }

    case "addAccount":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing arguments", details: nil))
        return
      }

      storeKey("username", value: args["username"] as? String)
      storeKey("accessToken", value: args["accessToken"] as? String)
      storeKey("refreshToken", value: args["refreshToken"] as? String)
      storeKey("profile", value: args["profile"] as? String)
      result(nil)

    case "checkAccount":
      let username = retrieveKey("username")
      let accessToken = retrieveKey("accessToken")

      if let username = username, let accessToken = accessToken {
        result([
          "username": username,
          "accessToken": accessToken,
          "refreshToken": retrieveKey("refreshToken") ?? "",
          "profile": retrieveKey("profile") ?? ""
        ])
      } else {
        result(nil)
      }

    case "removeAccount":
      deleteKey("username")
      deleteKey("accessToken")
      deleteKey("refreshToken")
      deleteKey("profile")
      result(true)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func storeKey(_ key: String, value: String?) {
    guard let value = value, let group = keychainGroup else {
      print("Missing keychain group or value.")
      return
    }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: "com.rpsmobile.sso",
      kSecAttrAccount as String: key,
      kSecAttrAccessGroup as String: group,
      kSecValueData as String: value.data(using: .utf8)!
    ]

    SecItemDelete(query as CFDictionary)
    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
      print("Error saving key \(key): \(status)")
    }
  }

  private func retrieveKey(_ key: String) -> String? {
    guard let group = keychainGroup else {
      print("Keychain group not configured.")
      return nil
    }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: "com.rpsmobile.sso",
      kSecAttrAccount as String: key,
      kSecAttrAccessGroup as String: group,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject? = nil
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    if status == errSecSuccess, let data = dataTypeRef as? Data {
      return String(data: data, encoding: .utf8)
    } else {
      print("Key not found \(key), status: \(status)")
      return nil
    }
  }

  private func deleteKey(_ key: String) {
    guard let group = keychainGroup else {
      print("Keychain group not configured.")
      return
    }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: "com.rpsmobile.sso",
      kSecAttrAccount as String: key,
      kSecAttrAccessGroup as String: group
    ]

    let status = SecItemDelete(query as CFDictionary)
    if status != errSecSuccess && status != errSecItemNotFound {
      print("Error deleting key \(key): \(status)")
    }
  }
}
