import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://localhost:8000/api/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception(response.data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
