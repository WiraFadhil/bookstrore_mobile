// lib/auth/auth_gate.dart

import 'package:final_project/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/auth/login_or_register.dart'; // Ganti nama_proyek_auth
import 'package:final_project/screens/home_page.dart'; // Ganti nama_proyek_auth

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika pengguna sudah login
          if (snapshot.hasData) {
            return MainScreen();
          }
          // Jika pengguna belum login
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
