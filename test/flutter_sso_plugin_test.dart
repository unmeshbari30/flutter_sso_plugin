import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sso_plugin/flutter_sso_plugin.dart';
import 'package:flutter_sso_plugin/flutter_sso_plugin_platform_interface.dart';
import 'package:flutter_sso_plugin/flutter_sso_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSsoPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSsoPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterSsoPluginPlatform initialPlatform = FlutterSsoPluginPlatform.instance;

  test('$MethodChannelFlutterSsoPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSsoPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterSsoPlugin flutterSsoPlugin = FlutterSsoPlugin();
    MockFlutterSsoPluginPlatform fakePlatform = MockFlutterSsoPluginPlatform();
    FlutterSsoPluginPlatform.instance = fakePlatform;

    expect(await flutterSsoPlugin.getPlatformVersion(), '42');
  });
}
