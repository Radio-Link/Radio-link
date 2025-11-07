import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000/api/auth"; // change for production
  static const storage = FlutterSecureStorage();

  // Register user
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return _handleResponse(response);
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return _handleResponse(response);
  }

  // Save JWT
  static Future<void> saveToken(String token) async {
    await storage.write(key: "jwt", value: token);
  }

  // Load JWT
  static Future<String?> getToken() async {
    return await storage.read(key: "jwt");
  }

  // Handle HTTP responses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Unknown error occurred");
    }
  }
}
