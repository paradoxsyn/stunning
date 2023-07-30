import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to keep track of the user's login status
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPass(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign up: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPass(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Add other authentication methods (e.g., Google Sign-In) as needed
}
