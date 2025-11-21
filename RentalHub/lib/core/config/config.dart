import 'package:flutter/foundation.dart';

class Config {
  // Defaults
  static const String _devBaseUrl = 'http://localhost:8080';
  static const String _prodBaseUrl = 'https://renthub-4.onrender.com';

  // Optional override provided at build time
  // Example: flutter build web --release --dart-define=API_BASE_URL=https://your-api.example.com
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    return kReleaseMode ? _prodBaseUrl : _devBaseUrl;
  }
}
