import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState(); // Gunakan const untuk efisiensi memori

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String token;
  final int userId;

  AuthSuccess(this.token, this.userId);
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
