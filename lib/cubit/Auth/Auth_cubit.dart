import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_repository.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(email, password);

      print("AuthCubit received response: $response");

      if (response.isEmpty) {
        emit(AuthFailure("Login gagal: Response kosong"));
        return;
      }

      if (response['success'] == true) {
        // Login berhasil, email sudah diverifikasi
        final token = response['access_token'] ?? "";
        final user = response['user'];

        await saveToken(token);
        await saveUserId(user['id']);
        emit(AuthSuccess(token, user['id']));
      } else if (response['email_verified'] == false) {
        // Kasus khusus: email belum diverifikasi
        final userId = response['user_id'];
        await resendVerificationEmail(userId);
        emit(AuthEmailNotVerified(userId, email));
      } else {
        // Login gagal karena alasan lain
        emit(AuthFailure(response['message'] ?? "Login gagal"));
      }
    } catch (e) {
      print("AuthCubit login error: $e");
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> resendVerificationEmail(int userId) async {
    try {
      print("Mengirim ulang email verifikasi untuk user_id: $userId");
      await _authRepository.resendVerificationEmail(userId);
    } catch (e) {
      print("Gagal mengirim ulang email verifikasi: $e");
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<int?> fetchUserId(String token) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        "https://adminduk-kec-puger.my.id/api/user",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return response.data['id'];
      }
    } catch (e) {
      print("Fetch user ID error: $e");
    }
    return null;
  }

  Future<void> loaduser() async {
    final token = await getToken();
    final userId = await getUserId();

    if (token != null && userId != null) {
      emit(AuthSuccess(token, userId));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    emit(AuthInitial());
  }

  Future<Map<String, dynamic>?> getProfile(int userId) async {
    try {
      final token = await getToken();
      if (token != null) {
        Dio dio = Dio();
        Response response = await dio.get(
          "https://adminduk-kec-puger.my.id/api/user",
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        if (response.statusCode == 200) {
          return response.data;
        }
      }
    } catch (e) {
      print("Fetch profile error: $e");
    }
    return null;
  }

  Future<void> updateProfile(
    int userId,
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      emit(AuthLoading());
      final token = await getToken();
      if (token != null) {
        Dio dio = Dio();
        Response response = await dio.post(
          "https://adminduk-kec-puger.my.id/api/updateprofile/$userId",
          data: {
            'name': name,
            'email': email,
            'phone': phone,
            'password': password,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        if (response.statusCode == 200) {
          emit(AuthSuccess(token, userId));
        } else {
          emit(AuthFailure("Gagal mengupdate profil"));
        }
      } else {
        emit(AuthFailure("Token tidak ditemukan"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<bool> deleteAccount(int userId) async {
    try {
      final token = await getToken();
      if (token != null) {
        Dio dio = Dio();
        Response response = await dio.delete(
          "https://adminduk-kec-puger.my.id/api/deleteaccount/$userId",
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        if (response.statusCode == 200) {
          await logout();
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Delete account error: $e");
      return false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String address,
    String nik,
    String nokk,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.register(
        name,
        email,
        phone,
        password,
        address,
        nik,
        nokk,
      );
      print("Response dari backend: $result");

      if (result['success']) {
        final message = result['data']['message'];
        emit(AuthRegistrationSuccess(message));
      } else {
        emit(AuthFailure(result['message'] ?? "Registrasi gagal"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
