import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
    required List<XFile> images,
    String category = 'PROPERTY',
    String? uploadedBy,
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
      if (uploadedBy != null && uploadedBy.isNotEmpty) {
        request.fields['uploadedBy'] = uploadedBy;
      }

      // Add image files - web compatible
      for (var image in images) {
        var bytes = await image.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'images',
          bytes,
          filename: image.name,
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

  /// Update property by ID
  static Future<Map<String, dynamic>> updateProperty({
    required String id,
    required String title,
    required String location,
    required int price,
    required String category,
    List<XFile>? images,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/properties/$id'),
      );

      // Add text fields
      request.fields['title'] = title;
      request.fields['location'] = location;
      request.fields['price'] = price.toString();
      request.fields['category'] = category;

      // Add image files if provided
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          var bytes = await image.readAsBytes();
          var multipartFile = http.MultipartFile.fromBytes(
            'images',
            bytes,
            filename: image.name,
          );
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Update failed: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Network error: $e'};
    }
  }
}
