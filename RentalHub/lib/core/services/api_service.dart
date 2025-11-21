import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://renthub-4.onrender.com";

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

  // Create property with multipart (image + fields)
  // NOTE: confirm the endpoint path with your backend (I used '/properties').
  // If your backend expects different field names or image key, update accordingly.
  static Future<Map<String, dynamic>> createProperty({
    required String title,
    required String price,
    String? oldPrice,
    String? delivery,
    required File imageFile,
    String? authToken,
  }) async {
    final uri = Uri.parse('$baseUrl/properties');
    final request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['price'] = price;
    if (oldPrice != null) request.fields['oldPrice'] = oldPrice;
    if (delivery != null) request.fields['delivery'] = delivery;

    final multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(multipartFile);

    request.headers['Accept'] = 'application/json';
    if (authToken != null && authToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $authToken';
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    // It's useful to check status code: you can throw or return error structure
    if (streamedResponse.statusCode < 200 || streamedResponse.statusCode >= 300) {
      // try to provide server message if any
      try {
        final decoded = jsonDecode(responseBody);
        return {'success': false, 'status': streamedResponse.statusCode, 'body': decoded};
      } catch (_) {
        return {'success': false, 'status': streamedResponse.statusCode, 'body': responseBody};
      }
    }

    return jsonDecode(responseBody) as Map<String, dynamic>;
  }
}
