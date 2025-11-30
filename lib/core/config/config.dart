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

    // Use production URL in release mode, localhost in debug mode
    String url;
    if (kReleaseMode) {
      url = _prodBaseUrl; // Production: Render backend
    } else if (kIsWeb) {
      url = _devBaseUrl; // Web debug: localhost:8080
    } else {
      // Mobile debug: Use 10.0.2.2 for Android emulator
      // For physical device, replace with your computer's IP (e.g., '192.168.1.100:8080')
      url = 'http://10.0.2.2:8080';
    }

    print('🔗 API Base URL: $url (Release: $kReleaseMode, IsWeb: $kIsWeb)');
    return url;
  }
}
