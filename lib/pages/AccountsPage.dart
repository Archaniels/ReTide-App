import 'package:flutter/material.dart';
// ============================ PAGES ============================
import 'LoginPage.dart';
import 'RegisterPage.dart';
// ============================ END ============================

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  // Widget pembantu untuk membuat baris Label dan TextField
  Widget _buildTextField(String label, String initialValue) {
    // Warna latar belakang gelap untuk input field
    const inputFillColor = Color(0xFF1E1E1E); 
    // Warna utama (teal/hijau muda)
    const primaryColor = Color(0xFF63CFC0); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          initialValue: initialValue,
          style: const TextStyle(color: Colors.white),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            filled: true,
            fillColor: inputFillColor, 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: primaryColor, width: 1.0), 
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna utama (teal/hijau muda)
    const primaryColor = Color(0xFF63CFC0); 
    // Warna latar belakang card/kontainer
    const cardBackgroundColor = Color(0xFF1E1E1E); 

    return Scaffold(
      backgroundColor: Colors.black,
      // ============================ AppBar ============================
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        // Menghilangkan tombol back default jika ini adalah halaman utama akun,
        // atau biarkan jika ada navigasi ke halaman ini.
        // Jika perlu tombol back:
        // leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      // ============================ END ============================

      // ============================ Hamburger Menu (Dibiarkan Sesuai Kode Asli) ============================
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Text(
                'ReTide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      // ============================ END ============================

      // ============================ Body Content ============================
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 100.0, // Memberi ruang dari AppBar
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- Title Section ---
            const Text(
              'Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor, // Warna teal/hijau muda
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Pengaturan akun, profil, dan preferensi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30.0),
            // --- End Title Section ---

            // --- Account Settings Card ---
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cardBackgroundColor, 
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 30.0), 
                  
                  // Username Field
                  _buildTextField('Username:', 'Bagaskara'),
                  const SizedBox(height: 20.0),

                  // Email Field
                  _buildTextField('Email:', 'bagaskara@gmail.com'),
                  const SizedBox(height: 20.0),

                  // No Telp Field
                  _buildTextField('No Telp:', ''),
                  const SizedBox(height: 40.0),

                  // Action Buttons
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      // Update Settings Button (Warna Teal/Hijau Muda)
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, 
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Update Settings',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // Delete Account Button (Warna Merah)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F), // Warna merah
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // --- End Account Settings Card ---
          ],
        ),
      ),
      // ============================ END Body Content ============================
    );
  }
}