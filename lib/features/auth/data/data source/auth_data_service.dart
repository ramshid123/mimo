import 'package:firebase_auth/firebase_auth.dart';
import 'package:mimo/core/error/exception.dart';

abstract interface class AuthService {
  Future<void> login({required String email, required String password});

  Future<String> signup({required String email, required String password});

  Future logout();

  Future<User?> getCurrentUser();

  Future sendPasswordResetEmail(String email);

  Future<void> sendVerificationEmail();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth authInstance;

  AuthServiceImpl(this.authInstance);

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await authInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<String> signup(
      {required String email, required String password}) async {
    try {
      final response = await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      return response.user!.uid;
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = authInstance.currentUser;
      return response;
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future logout() async {
    try {
      await authInstance.signOut();
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future sendPasswordResetEmail(String email) async {
    try {
      await authInstance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      if (authInstance.currentUser != null) {
        await authInstance.currentUser!.sendEmailVerification();
      }
    } catch (e) {
      throw KustomException(e.toString());
    }
  }
}
