import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_preferences/enhanced_preferences.dart';
import 'package:enhanced_preferences/enhanced_preferences_platform_interface.dart';
import 'package:enhanced_preferences/enhanced_preferences_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEnhancedPreferencesPlatform
    with MockPlatformInterfaceMixin
    implements EnhancedPreferencesPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EnhancedPreferencesPlatform initialPlatform = EnhancedPreferencesPlatform.instance;

  test('$MethodChannelEnhancedPreferences is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEnhancedPreferences>());
  });

  test('getPlatformVersion', () async {
    EnhancedPreferences enhancedPreferencesPlugin = EnhancedPreferences();
    MockEnhancedPreferencesPlatform fakePlatform = MockEnhancedPreferencesPlatform();
    EnhancedPreferencesPlatform.instance = fakePlatform;

    expect(await enhancedPreferencesPlugin.getPlatformVersion(), '42');
  });
}
