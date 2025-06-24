// import 'package:flutter/services.dart';

// class AndroidSSO {
//   static const _channel = MethodChannel("com.example.sso/account");

//   static Future<void> saveAccount({
//     required String username,
//     required String accessToken,
//     String? refreshToken,
//     String? profileJson,
//   }) async {
//     await _channel.invokeMethod("addAccount", {
//       "username": username,
//       "accessToken": accessToken,
//       "refreshToken": refreshToken,
//       "profile": profileJson,
//     });
//   }

//   static Future<Map?> getAccount() async {
//     return await _channel.invokeMethod<Map>("checkAccount");
//   }
// }
