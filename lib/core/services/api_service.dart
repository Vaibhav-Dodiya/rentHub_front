import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loginsignup/core/config/config.dart';

class ApiService {
  static String get baseUrl => Config.baseUrl;

  static Future<Map<String, dynamic>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  /// Upload property with multiple images to backend
  static Future<Map<String, dynamic>> uploadProperty({
    required String title,
    required String location,
    required int price,
    required List<File> images,
    String category = 'PROPERTY',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/properties/upload-files'),
      );

      // Add text fields
      request.fields['title'] = title;
      request.fields['location'] = location;
      request.fields['price'] = price.toString();
      request.fields['category'] = category;

      // Add image files
      for (var image in images) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: image.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Upload failed: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Network error: $e'};
    }
  }

  /// Fetch all properties from backend
  static Future<List<dynamic>> getAllProperties() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/properties'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      // Error fetching properties
      return [];
    }
  }

  /// Fetch properties by category from backend
  static Future<List<dynamic>> getPropertiesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/properties/category/$category'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      // Error fetching properties by category
      return [];
    }
  }

  /// Delete property by ID
  static Future<bool> deleteProperty(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/properties/$id'),
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      // Error deleting property
      return false;
    }
  }
}
