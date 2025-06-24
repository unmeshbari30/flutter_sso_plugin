import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_sso_plugin_platform_interface.dart';

/// An implementation of [FlutterSsoPluginPlatform] that uses method channels.
class MethodChannelFlutterSsoPlugin extends FlutterSsoPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sso_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
