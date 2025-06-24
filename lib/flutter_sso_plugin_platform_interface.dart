import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sso_plugin_method_channel.dart';

abstract class FlutterSsoPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterSsoPluginPlatform.
  FlutterSsoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSsoPluginPlatform _instance = MethodChannelFlutterSsoPlugin();

  /// The default instance of [FlutterSsoPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSsoPlugin].
  static FlutterSsoPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSsoPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterSsoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
