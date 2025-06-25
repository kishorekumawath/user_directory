// services/api_service.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  static Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get('/users');
      
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      
      if (response.statusCode == 200) {
        List<dynamic> usersJson = response.data;
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      print('Error Type: ${e.type}');
      if (e.response != null) {
        print('Error Status: ${e.response?.statusCode}');
        print('Error Data: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('General Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Optional: Fetch single user by ID
  static Future<UserModel> fetchUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('General Error: $e');
      throw Exception('Network error: $e');
    }
  }
}