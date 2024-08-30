part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

// Initial State
final class AuthInitial extends AuthState {}

// Signup State
sealed class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {
  final String error;

  SignupFailed(this.error);
}

// Login State
sealed class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

// Forgot Password State
sealed class ForgotPasswordState extends AuthState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {}

final class ForgotPasswordFailed extends ForgotPasswordState {
  final String error;

  ForgotPasswordFailed(this.error);
}

// Reset Password State
sealed class ResetPasswordState extends AuthState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {}

final class ResetPasswordFailed extends ResetPasswordState {
  final String error;

  ResetPasswordFailed(this.error);
}
