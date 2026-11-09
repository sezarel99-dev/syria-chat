import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, auth) {
        if (auth.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }
        final user = auth.data;
        if (user == null) return const LoginScreen();
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, profile) {
            if (profile.connectionState == ConnectionState.waiting) return const _LoadingScreen();
            final data = profile.data?.data();
            final complete = data != null &&
                (data['displayName'] as String? ?? '').trim().isNotEmpty &&
                (data['username'] as String? ?? '').trim().isNotEmpty;
            if (!complete) return const ProfileSetupScreen();
            return const HomeScreen();
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFF090909),
    body: Center(child: CircularProgressIndicator(color: Color(0xFFC9A45C))),
  );
}
