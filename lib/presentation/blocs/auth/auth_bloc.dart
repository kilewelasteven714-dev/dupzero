import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheck);
    on<SignInWithGoogleEvent>(_onGoogle);
    on<SignInWithEmailEvent>(_onEmailIn);
    on<SignUpWithEmailEvent>(_onEmailUp);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheck(CheckAuthStatusEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final r = await _repo.getCurrentUser();
    r.fold(
      (f) => emit(AuthUnauthenticated()),
      (u) => u != null ? emit(AuthAuthenticated(u)) : emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onGoogle(SignInWithGoogleEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final r = await _repo.signInWithGoogle();
    r.fold((f) => emit(AuthError(f.message)), (u) => emit(AuthAuthenticated(u)));
  }

  Future<void> _onEmailIn(SignInWithEmailEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final r = await _repo.signInWithEmail(e.email, e.password);
    r.fold((f) => emit(AuthError(f.message)), (u) => emit(AuthAuthenticated(u)));
  }

  Future<void> _onEmailUp(SignUpWithEmailEvent e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final r = await _repo.signUpWithEmail(e.email, e.password);
    r.fold((f) => emit(AuthError(f.message)), (u) => emit(AuthAuthenticated(u)));
  }

  Future<void> _onSignOut(SignOutEvent e, Emitter<AuthState> emit) async {
    await _repo.signOut();
    emit(AuthUnauthenticated());
  }
}
