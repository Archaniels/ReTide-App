import 'package:flutter/material.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'RegisterPage.dart';
// ============================ END ============================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(
        child: Text('This is the login page'),
      ),
    );
  }
}