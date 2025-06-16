import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://adminduk-kec-puger.my.id/api/login',
        data: {'email': email, 'password': password},
      );

      print("Login response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Login error: $e");
      if (e is DioException && e.response != null) {
        print("Error response: ${e.response!.data}");

        // Jika status 403 dan error terkait email belum diverifikasi
        if (e.response!.statusCode == 403 &&
            e.response!.data['email_verified'] == false) {
          return e.response!.data; // Kembalikan response dari server
        }

        return {
          'success': false,
          'message': e.response!.data['message'] ?? 'Login gagal',
        };
      }
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<void> resendVerificationEmail(int userId) async {
    try {
      await _dio.post(
        "https://adminduk-kec-puger.my.id/api/email/resend-by-id",
        data: {"user_id": userId},
      );
      print("Email verifikasi berhasil dikirim");
    } catch (e) {
      print("Gagal mengirim ulang email verifikasi: $e");
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String address,
    String nik,
    String nokk,
    String photoPath,
  ) async {
    try {
      Dio dio = Dio();

      // Create FormData for multipart/form-data
      var formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'address': address,
        'nik': nik,
        'nokk': nokk,
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: 'profile_photo.jpg',
        ),
      });

      Response response = await dio.post(
        "https://adminduk-kec-puger.my.id/api/register",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'message': 'Gagal melakukan registrasi'};
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        // Handle validation errors from the server
        if (e.response!.statusCode == 422 &&
            e.response!.data['errors'] != null) {
          final errors = e.response!.data['errors'];
          final errorMsg = errors.entries.first.value[0] ?? 'Validation error';
          return {'success': false, 'message': errorMsg};
        }
      }
      return {'success': false, 'message': e.toString()};
    }
  }
}
