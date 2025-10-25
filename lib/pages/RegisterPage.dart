import 'package:flutter/material.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'LoginPage.dart';
// ============================ END ============================

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(
        child: Text('This is the register page'),
      ),
    );
  }
}