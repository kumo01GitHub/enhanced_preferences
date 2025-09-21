# Enhanced shared preferences plugin

Wraps platform-specific persistent storage for simple data. Supported data types are `String`, `int`, `double` and `bool`.

| Platform | Storage | Keystore |
| ---- | ---- | ---- |
| Android | DataStore Preferences | Android Keystore |
| iOS | NSUserDefaults | Keychain |
| Web | localStorage | NOT SUPPORTED |

## Usage

### Write data

```dart
final EnhancedPreferences prefs = EnhancedPreferences();

// Specify options.
final EnhancedPreferencesOptions options = EnhancedPreferencesOptions();

// Save an String value to 'hello' key.
await prefs.setString('hello', 'World', options);
// Save an integer value to 'counter' key.
await prefs.setInt('counter', 10, options);
// Save an double value to 'rate' key.
await prefs.setDouble('rate', 0.9, options);
// Save an boolean value to 'isActive' key.
await prefs.setBool('isActive', true, options);
```

### Read data

```dart
final EnhancedPreferences prefs = EnhancedPreferences();

// Specify options.
final EnhancedPreferencesOptions options = EnhancedPreferencesOptions();

// Try reading data from the 'Hello' key.
final String? hello = await prefs.getString('hello', options);
// Try reading data from the 'counter' key.
final int? counter = await prefs.getInt('counter', options);
// Try reading data from the 'rate' key.
final double? rate = await prefs.getDouble('rate', options);
// Try reading data from the 'isActive' key.
final bool? isActive = await prefs.getBool('isActive', options);
```

### Remove an entry

```dart
// Remove data for the 'hello' key.
await prefs.remove('hello');
```

### Options

| Option | Type | Detail | Default |
| ---- | ---- | ---- | ---- |
| enableCache | bool | When the option is true, cache the key-value. | true |
| enableEncryption | bool | When the option is true, encrypt the value and store it. Only supports Android and iOS. | false |

## Errors

| Error code | Detail |
| ---- | ---- |
| INVALID_ARGUMENT | Invalid arguments such as the key is blank. |
| REFERENCE_ERROR | Failed to obtain the value for key. |
| ILLEGAL_ACCESS | Failed to encrypt / decrypt the value for key. |
| UNKNOWN_ERROR | Other causes. |

---

<a href="https://www.buymeacoffee.com/kumo01" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
