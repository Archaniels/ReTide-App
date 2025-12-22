import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menangkap teks yang diinput user pada kolom Email & Password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;

  // FUNGSI UTAMA: Menangani logika Login ke Firebase
  Future<void> _handleLogin() async {
    // Ubah tampilan menjadi loading (tombol berputar)
    setState(() => _isLoading = true);

    try {
      //  Memanggil fungsi Firebase untuk cek email dan password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );

      // Jika login berhasil, pindahkan user ke HomePage
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false, 
        );
      }
    } on FirebaseAuthException catch (e) {
      // Jika login gagal (contoh: pass salah), tampilkan pesan error lewat SnackBar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login Gagal")));
    } finally {
      // Setelah selesai (berhasil/gagal), matikan status loading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 17), 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              
              _buildInput(_emailController, 'Email', Icons.email),
              
              _buildInput(
                _passwordController,
                'Password',
                Icons.lock,
                isObscure: true,
              ),
              
              const SizedBox(height: 24),
              
              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator() 
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                ),
              ),
              
              // TOMBOL PINDAH KE REGISTER
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text(
                  'Belum punya akun? Register',
                  style: TextStyle(color: Color(0xFF63CFC0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isObscure = false, 
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isObscure, 
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1E1E1E), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, 
          ),
        ),
      ),
    );
  }
}