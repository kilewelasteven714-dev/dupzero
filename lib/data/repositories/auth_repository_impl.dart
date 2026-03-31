import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  // Convert Firebase user to our UserProfile
  UserProfile _toProfile(fb.User user) => UserProfile(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );

  @override
  Future<Either<Failure, UserProfile>> signInWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) return const Left(AuthFailure('Google sign-in cancelled'));

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return Right(_toProfile(result.user!));
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Google sign-in failed'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signInWithEmail(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(_toProfile(result.user!));
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_friendlyError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signUpWithEmail(
      String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Right(_toProfile(result.user!));
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_friendlyError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _google.signOut()]);
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return const Right(null);
    return Right(_toProfile(user));
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_friendlyError(e.code)));
    }
  }

  @override
  Stream<UserProfile?> get authStateChanges =>
      _auth.authStateChanges().map((u) => u == null ? null : _toProfile(u));

  // Friendly error messages
  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':     return 'No account found with this email.';
      case 'wrong-password':     return 'Incorrect password. Please try again.';
      case 'email-already-in-use': return 'An account already exists with this email.';
      case 'weak-password':      return 'Password must be at least 6 characters.';
      case 'invalid-email':      return 'Please enter a valid email address.';
      case 'user-disabled':      return 'This account has been disabled.';
      case 'too-many-requests':  return 'Too many attempts. Please try again later.';
      case 'network-request-failed': return 'No internet connection. Check your network.';
      default: return 'Authentication failed. Please try again.';
    }
  }
}
