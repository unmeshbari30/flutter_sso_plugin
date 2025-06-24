import 'package:flutter/services.dart';

class FlutterSsoPlugin {
  // static const _channel = MethodChannel("com.example.sso/account");
  static const _channel = MethodChannel("com.rpsmobile.sso/account");
  static String? _keychainGroup;

  Future<String?> getPlatformVersion() {
  return _channel.invokeMethod("getPlatformVersion", { });
}


  static Future<void> configure({required String keychainGroup}) async {
    _keychainGroup = keychainGroup;
    await _channel.invokeMethod("configure", {
      "keychainGroup": keychainGroup,
    });
  }

  static Future<void> saveAccount({
    required String username,
    required String accessToken,
    String? refreshToken,
    String? profileJson,
  }) async {
    await _channel.invokeMethod("addAccount", {
      "username": username,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "profile": profileJson,
    });
  }

  static Future<Map<String, String>?> getAccount() async {
    final result = await _channel.invokeMethod<Map>("checkAccount");
    return result?.map((k, v) => MapEntry(k.toString(), v.toString()));
  }

  static Future<bool> removeAccount() async {
    final result = await _channel.invokeMethod("removeAccount");
    return result == true;
  }
}

