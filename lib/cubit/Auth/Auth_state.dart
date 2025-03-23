import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

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
  AuthFailure(this.error);
}

class AuthEmailNotVerified extends AuthState {
  final int userId;
  final String email;

  AuthEmailNotVerified(this.userId, this.email);
}

class AuthVerificationEmailSent extends AuthState {}

class AuthRegistrationSuccess extends AuthState {
  final String email;

  AuthRegistrationSuccess(this.email);
}
