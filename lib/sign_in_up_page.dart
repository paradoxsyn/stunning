import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stunning/home_page.dart';
import 'auth_service.dart';

class AuthenticationManager {
  final AuthService _auth = AuthService();

  Future<User?> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPass(email, password);
  }

  Future<User?> signUp(String email, String password) async {
    return await _auth.signUpWithEmailAndPass(email, password);
  }
}

class SignInUpPage extends StatefulWidget {
  const SignInUpPage({super.key});

  @override
  SignInUpPageState createState() => SignInUpPageState();
}

class SignInUpPageState extends State<SignInUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationManager _authManager = AuthenticationManager();

  bool _isSigningIn =
      true; // Variable to track whether the user is signing in or signing up

  // Add this GlobalKey to access the ScaffoldState
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text(_isSigningIn ? 'Sign In' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Set the desired padding here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isSigningIn
                    ? () => _signIn(context)
                    : () => _signUp(context),
                child: Text(_isSigningIn
                    ? 'Sign In'
                    : 'Sign Up'), // Apply the customButtonStyle
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () =>
                    _resetPassword(context), // Call the reset password method
                child: const Text('Reset Password'),
              ),
              const SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSigningIn = !_isSigningIn;
                  });
                },
                child: Text(_isSigningIn
                    ? 'Create an account'
                    : 'Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle sign in
  void _signIn(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    final navigator = Navigator.of(context); // store the Navigator
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    User? user = await _authManager.signIn(email, password);
    if (user != null) {
      // Sign in successful, do something (e.g., navigate to the next screen)
      // Sign in successful, navigate to the home page
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(
            title: 'Login Test',
          ),
        ),
      );
    } else {
      // Sign in failed, display an error message or handle the failure
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('Sign in failed. Please check your credentials.')),
      );
    }
  }

  // Function to handle sign up
  void _signUp(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    final navigator = Navigator.of(context); // store the Navigator
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    User? user = await _authManager.signUp(email, password);
    if (user != null) {
      // Sign up successful, do something (e.g., navigate to the next screen)
      await _sendVerificationEmail(user);
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(
            title: 'Signup Test',
          ),
        ),
      );
    } else {
      // Sign up failed, display an error message or handle the failure
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('Sign up failed. Please check your credentials.')),
      );
    }
  }

  // Function to send a verification email to the user
  Future<void> _sendVerificationEmail(User user) async {
    if (user.emailVerified) {
      return; // Email already verified, no need to send again
    }

    await user.sendEmailVerification();
  }

  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully, show a success message
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your email inbox.'),
        ),
      );
    } catch (e) {
      // Failed to send password reset email, show an error message
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to send password reset email. Please check your email address.'),
        ),
      );
    }
  }
}
