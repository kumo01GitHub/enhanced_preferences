import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_preferences/enhanced_preferences_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEnhancedPreferences platform =
      MethodChannelEnhancedPreferences();
  const MethodChannel channel = MethodChannel('enhanced_preferences');
  Map<String, dynamic> mockPreferences = <String, dynamic>{};

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getString':
              final String key = methodCall.arguments['key'];
              return mockPreferences[key] as String?;
            case 'setString':
              final String key = methodCall.arguments['key'];
              mockPreferences[key] = methodCall.arguments['value'] as String;
              return key;
            case 'getInt':
              final String key = methodCall.arguments['key'];
              return mockPreferences[key] as int?;
            case 'setInt':
              final String key = methodCall.arguments['key'];
              mockPreferences[key] = methodCall.arguments['value'] as int;
              return key;
            case 'getDouble':
              final String key = methodCall.arguments['key'];
              return mockPreferences[key] as double?;
            case 'setDouble':
              final String key = methodCall.arguments['key'];
              mockPreferences[key] = methodCall.arguments['value'] as double;
              return key;
            case 'getBool':
              final String key = methodCall.arguments['key'];
              return mockPreferences[key] as bool?;
            case 'setBool':
              final String key = methodCall.arguments['key'];
              mockPreferences[key] = methodCall.arguments['value'] as bool;
              return key;
            default:
              throw UnimplementedError();
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('String', () async {
    final String key = "stringKey";
    final String value = "stringValue";

    expect(await platform.setString(key, value), key);
    expect(await platform.getString(key), value);
  });

  test('Int', () async {
    final String key = "intKey";
    final int value = 999;

    expect(await platform.setInt(key, value), key);
    expect(await platform.getInt(key), value);
  });

  test('Double', () async {
    final String key = "doubleKey";
    final double value = 999.99;

    expect(await platform.setDouble(key, value), key);
    expect(await platform.getDouble(key), value);
  });

  test('Bool', () async {
    final String key = "boolKey";
    final bool value = true;

    expect(await platform.setBool(key, value), key);
    expect(await platform.getBool(key), value);
  });
}
