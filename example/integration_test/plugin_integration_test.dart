// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:enhanced_preferences/enhanced_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('setString/getString test', (WidgetTester tester) async {
    final EnhancedPreferences prefs = EnhancedPreferences();
    await prefs.setString('hello', 'World');
    expect(await prefs.getString('hello'), 'World');
  });

  testWidgets('setInt/getInt test', (WidgetTester tester) async {
    final EnhancedPreferences prefs = EnhancedPreferences();
    await prefs.setInt('counter', 10);
    expect(await prefs.getInt('counter'), 10);
  });

  testWidgets('setDouble/getDouble test', (WidgetTester tester) async {
    final EnhancedPreferences prefs = EnhancedPreferences();
    await prefs.setDouble('rate', 0.9);
    expect(await prefs.getDouble('rate'), 0.9);
  });

  testWidgets('setBool/getBool test', (WidgetTester tester) async {
    final EnhancedPreferences prefs = EnhancedPreferences();
    await prefs.setBool('isActive', true);
    expect(await prefs.getBool('isActive'), true);
  });
}
