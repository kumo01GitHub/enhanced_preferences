import 'package:flutter/material.dart';

import 'package:enhanced_preferences/enhanced_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _enhancedPreferencesPlugin = EnhancedPreferences();

  String? _type;
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  dynamic _result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Center(
              child: Column(
                spacing: 20,
                children: [
                  // KEY
                  Row(
                    spacing: 10,
                    children: [
                      Text('KEY:'),
                      DropdownButton(
                        items: [
                          DropdownMenuItem(value: "String", child: Text("String")),
                          DropdownMenuItem(value: "Int", child: Text("Integer")),
                          DropdownMenuItem(value: "Double", child: Text("Double")),
                          DropdownMenuItem(value: "Bool", child: Text("Boolean")),
                        ],
                        onChanged: (String? value) { setState(() { _type = value; }); },
                        value: _type,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _keyController,
                          decoration: InputDecoration(hintText: 'Enter key'),
                        ),
                      ),
                    ]
                  ),
                  // VALUE
                  Row(
                    spacing: 10,
                    children: [
                      Text('VALUE:'),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _valueController,
                          decoration: InputDecoration(hintText: 'Enter value'),
                        ),
                      ),
                    ]
                  ),
                  // BUTTONS
                  Row(
                    children: [
                      // GET
                      ElevatedButton(
                        onPressed: () async {
                          if (_keyController.text.isEmpty) {
                            return;
                          }

                          dynamic result;
                          try {
                            if (_type == "String") {
                              result = await _enhancedPreferencesPlugin.getString(_keyController.text);
                            } else if (_type == "Int") {
                              result = await _enhancedPreferencesPlugin.getInt(_keyController.text);
                            } else if (_type == "Double") {
                              result = await _enhancedPreferencesPlugin.getDouble(_keyController.text);
                            } else if (_type == "Bool") {
                              result = await _enhancedPreferencesPlugin.getBool(_keyController.text);
                            }
                          } on Exception catch (e) {
                            result = e.toString();
                          }

                          setState(() { _result = result; });
                        },
                        child: Text('GET'),
                      ),
                      // SET
                      ElevatedButton(
                        onPressed: () async {
                          if (_keyController.text.isEmpty) {
                            return;
                          }

                          dynamic result;
                          try {
                            if (_type == "String") {
                              result = await _enhancedPreferencesPlugin.setString(_keyController.text, _valueController.text);
                            } else if (_type == "Int") {
                              final intValue = int.tryParse(_valueController.text) ?? 0;
                              result = await _enhancedPreferencesPlugin.setInt(_keyController.text, intValue);
                            } else if (_type == "Double") {
                              final doubleValue = double.tryParse(_valueController.text) ?? 0.0;
                              result = await _enhancedPreferencesPlugin.setDouble(_keyController.text, doubleValue);
                            } else if (_type == "Bool") {
                              final boolValue = (_valueController.text.toLowerCase() == 'true');
                              result = await _enhancedPreferencesPlugin.setBool(_keyController.text, boolValue);
                            }
                          } on Exception catch (e) {
                            result = e.toString();
                          }

                          setState(() { _result = result; });
                        },
                        child: Text('SET'),
                      ),
                    ],
                  ),
                  // RESULT
                  Text('${_result ?? ""}'),
                ]
              ),
            ),
          )
      ),
    );
  }
}
