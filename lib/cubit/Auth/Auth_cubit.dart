import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_repository.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';
import 'package:dio/dio.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.login(email, password);
      await saveToken(token);

      // Ambil user_id setelah login
      final userId = await fetchUserId(token);
      if (userId != null) {
        await saveUserId(userId);
        emit(AuthSuccess(token, userId)); // Emit dengan user_id
      } else {
        emit(AuthFailure("Gagal mendapatkan user ID"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<int?> fetchUserId(String token) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        "http://localhost:8000/api/user",
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
}
