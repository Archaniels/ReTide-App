import 'package:flutter/material.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'RegisterPage.dart';
import 'HomePage.dart';
// ============================ END ============================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      // ============================ AppBar ============================
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
        title: Text('ReTide', style: TextStyle(color: Colors.white)),
      ),

      // ============================ END ============================
      body: Align(
        alignment: Alignment.center,

        // ============================ Title and Subtitle ============================
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Column(
              children: [
                Text(
                  'Masukkan email dan password untuk login',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 64),
              ],
            ),

            // ============================ END ============================

            // ============================ Email TextField ============================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF63CFC0)),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),

            // ============================ END ============================
            SizedBox(height: 16),

            // ============================ Password Textfield ============================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF63CFC0)),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),

            // ============================ END ============================
            SizedBox(height: 16),

            // ============================ Text: Belum punya akun? ============================
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                "Belum punya akun? Daftar di sini",
                style: TextStyle(
                  color: Color(0xFF63CFC0),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            // ============================ END ============================
            const SizedBox(height: 16),

            // ============================ Login Button ============================
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },

              label: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // ============================ END ============================
          ],
        ),
      ),
    );
  }
}
