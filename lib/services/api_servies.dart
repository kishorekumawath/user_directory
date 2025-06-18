import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'https://randomuser.me/api';
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  static Future<UserResponse> fetchUsers({int results = 10}) async {
    try {
      final response = await _dio.get('/', queryParameters: {'results': results});
      
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      
      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
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
}