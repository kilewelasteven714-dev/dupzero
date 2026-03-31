import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

class UserProfile {
  final String id, email;
  final String? displayName, photoUrl;
  final bool isPremium;

  const UserProfile({
    required this.id, required this.email,
    this.displayName, this.photoUrl, this.isPremium = false,
  });
}

abstract class AuthRepository {
  Future<Either<Failure, UserProfile>> signInWithGoogle();
  Future<Either<Failure, UserProfile>> signInWithEmail(String email, String password);
  Future<Either<Failure, UserProfile>> signUpWithEmail(String email, String password);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, UserProfile?>> getCurrentUser();
  Future<Either<Failure, Unit>> resetPassword(String email);
  Stream<UserProfile?> get authStateChanges;
}
