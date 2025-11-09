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
  final _prefs = EnhancedPreferences();

  String? _type;
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  bool _enableCache = false;
  bool _enableEncryption = false;

  dynamic _result;

  @override
  void initState() {
    super.initState();

    final defaultOpts = EnhancedPreferencesOptions();
    _enableCache = defaultOpts.enableCache;
    _enableEncryption = defaultOpts.enableEncryption;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Padding(
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
                        DropdownMenuItem(
                          value: "String",
                          child: Text("String"),
                        ),
                        DropdownMenuItem(value: "Int", child: Text("Integer")),
                        DropdownMenuItem(
                          value: "Double",
                          child: Text("Double"),
                        ),
                        DropdownMenuItem(value: "Bool", child: Text("Boolean")),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _type = value;
                        });
                      },
                      value: _type,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _keyController,
                        decoration: InputDecoration(hintText: 'Enter key'),
                      ),
                    ),
                  ],
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
                  ],
                ),
                // OPTIONS
                Row(
                  spacing: 10,
                  children: [
                    // CACHE
                    Text('CACHE:'),
                    Switch(
                      value: _enableCache,
                      onChanged: (enable) async { setState(() { _enableCache = enable; }); },
                    ),
                    // ENCRYPTION
                    Text('ENCRYPTION:'),
                    Switch(
                      value: _enableEncryption,
                      onChanged: (enable) async { setState(() { _enableEncryption = enable; }); },
                    ),
                    Text(''),
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
                            result = await _prefs.getString(
                              _keyController.text,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Int") {
                            result = await _prefs.getInt(
                              _keyController.text,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Double") {
                            result = await _prefs.getDouble(
                              _keyController.text,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Bool") {
                            result = await _prefs.getBool(
                              _keyController.text,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          }
                        } on Exception catch (e) {
                          result = e.toString();
                        } on Error catch (e) {
                          result = e.toString();
                        }

                        setState(() {
                          _result = result;
                        });
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
                            result = await _prefs.setString(
                              _keyController.text,
                              _valueController.text,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Int") {
                            final intValue =
                                int.tryParse(_valueController.text) ?? 0;
                            result = await _prefs.setInt(
                              _keyController.text,
                              intValue,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Double") {
                            final doubleValue =
                                double.tryParse(_valueController.text) ?? 0.0;
                            result = await _prefs.setDouble(
                              _keyController.text,
                              doubleValue,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          } else if (_type == "Bool") {
                            final boolValue =
                                (_valueController.text.toLowerCase() == 'true');
                            result = await _prefs.setBool(
                              _keyController.text,
                              boolValue,
                              EnhancedPreferencesOptions(enableCache: _enableCache, enableEncryption: _enableEncryption)
                            );
                          }
                        } on Exception catch (e) {
                          result = e.toString();
                        } on Error catch (e) {
                          result = e.toString();
                        }

                        setState(() {
                          _result = result;
                        });
                      },
                      child: Text('SET'),
                    ),
                    // REMOVE
                    ElevatedButton(
                      onPressed: () async {
                        if (_keyController.text.isEmpty) {
                          return;
                        }

                        dynamic result;
                        try {
                          result = await _prefs.remove(_keyController.text);
                        } on Exception catch (e) {
                          result = e.toString();
                        } on Error catch (e) {
                          result = e.toString();
                        }

                        setState(() {
                          _result = result;
                        });
                      },
                      child: Text('REMOVE'),
                    ),
                    // KEYS
                    ElevatedButton(
                      onPressed: () async {
                        dynamic result;
                        try {
                          result = await _prefs.keys();
                        } on Exception catch (e) {
                          result = e.toString();
                        } on Error catch (e) {
                          result = e.toString();
                        }

                        setState(() {
                          _result = result;
                        });
                      },
                      child: Text('KEYS'),
                    ),
                  ],
                ),
                // RESULT
                Text('${_result ?? ""}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
