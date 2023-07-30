import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Replace this with the actual home page of your app
import 'sign_in_up_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            // User is not logged in, show the sign-up page
            return const SignInUpPage();
          } else {
            // User is logged in, show the home page
            return const HomePage(
                title:
                    'Home User Still Logged in'); // Replace this with the actual home page of your app
          }
        } else {
          // Connection state is not active, show a loading indicator or something else
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
