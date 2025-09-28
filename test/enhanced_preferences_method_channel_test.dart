import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_preferences/enhanced_preferences_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEnhancedPreferences platform =
      MethodChannelEnhancedPreferences();
  const MethodChannel channel = MethodChannel('enhanced_preferences');
  Map<String, dynamic> mockPreferences = <String, dynamic>{};

  T getItem<T>(String key) {
    if (mockPreferences.containsKey(key)) {
      return mockPreferences[key] as T;
    } else {
      throw PlatformException(
        code: 'REFERENCE_ERROR',
        message: 'Reference Error',
      );
    }
  }

  String setItem<T>(String key, T value) {
    mockPreferences[key] = value;
    return key;
  }

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getString':
              return getItem<String>(methodCall.arguments['key']);
            case 'setString':
              return setItem<String>(
                methodCall.arguments['key'],
                methodCall.arguments['value'],
              );
            case 'getInt':
              return getItem<int>(methodCall.arguments['key']);
            case 'setInt':
              return setItem<int>(
                methodCall.arguments['key'],
                methodCall.arguments['value'],
              );
            case 'getDouble':
              return getItem<double>(methodCall.arguments['key']);
            case 'setDouble':
              return setItem<double>(
                methodCall.arguments['key'],
                methodCall.arguments['value'],
              );
            case 'getBool':
              return getItem<bool>(methodCall.arguments['key']);
            case 'setBool':
              return setItem<bool>(
                methodCall.arguments['key'],
                methodCall.arguments['value'],
              );
            case 'remove':
              final String key = methodCall.arguments['key'];
              mockPreferences.remove(key);
              return key;
            case 'keys':
              return mockPreferences.keys.toList();
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

  test('Remove', () async {
    final String key = "keytoRemove";
    final String value = "valueToRemove";

    expect(await platform.setString(key, value), key);
    expect(await platform.getString(key), value);
    expect(await platform.remove(key), key);
    expect(() => platform.getString(key), throwsA(isA<PlatformException>()));
  });

  test('Keys', () async {
    final String key1 = "key1";
    final int value1 = 1;
    final String key2 = "key2";
    final double value2 = 2.0;

    expect(await platform.setInt(key1, value1), key1);
    expect(await platform.setDouble(key2, value2), key2);
    expect(await platform.keys(), containsAll([key1, key2]));

    expect(await platform.remove(key1), key1);
    expect((await platform.keys())?.contains(key1), false);
    expect(await platform.keys(), containsAll([key2]));
  });
}
