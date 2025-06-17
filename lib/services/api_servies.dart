import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';

  static Future<UserResponse> fetchUsers({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users?page=$page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}