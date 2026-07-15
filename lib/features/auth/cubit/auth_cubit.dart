import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(AuthInitial()) {
    // Force sign out on startup so the app always starts at the Login Screen
    _firebaseAuth.signOut();

    _authStateSubscription = _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(user));
      }
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseExceptionToMessage(e)));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      _authStateSubscription?.pause();
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.signOut();
      _authStateSubscription?.resume();
      emit(SignedUpSuccessfully());
    } on FirebaseAuthException catch (e) {
      _authStateSubscription?.resume();
      emit(AuthError(_mapFirebaseExceptionToMessage(e)));
    } catch (e) {
      _authStateSubscription?.resume();
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      emit(AuthError('An error occurred while signing out: ${e.toString()}'));
    }
  }

  String _mapFirebaseExceptionToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network connection error. Please try again.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
