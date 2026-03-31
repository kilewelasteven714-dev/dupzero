part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}
class SignInWithGoogleEvent extends AuthEvent {}
class SignOutEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email, password;
  const SignInWithEmailEvent(this.email, this.password);
  @override List<Object?> get props => [email, password];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email, password;
  const SignUpWithEmailEvent(this.email, this.password);
  @override List<Object?> get props => [email, password];
}
