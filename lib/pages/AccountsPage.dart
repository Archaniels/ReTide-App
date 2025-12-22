import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  
  // Controller untuk Form
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _phoneController = TextEditingController();
  
  bool _isUpdating = false;

  final Color primaryColor = const Color(0xFF63CFC0);
  final Color cardBackgroundColor = const Color(0xFF1E1E1E);

  // --- FUNGSI UPDATE DATA PROFIL ---
  Future<void> _updateProfile() async {
    setState(() => _isUpdating = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': user!.email, 
      }, SetOptions(merge: true)); 

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  // --- DIALOG GANTI PASSWORD ---
  void _showPasswordDialog() {
    final TextEditingController _oldPassController = TextEditingController();
    final TextEditingController _newPassController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackgroundColor,
        title: const Text('Ganti Password', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPopupTextField(_oldPassController, 'Password Lama', true),
            const SizedBox(height: 10),
            _buildPopupTextField(_newPassController, 'Password Baru', true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!, password: _oldPassController.text.trim());
                await user!.reauthenticateWithCredential(credential);
                await user!.updatePassword(_newPassController.text.trim());
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password diganti!')));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal: Password lama salah')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Simpan', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            // Isi controller jika field tidak kosong
            if (_usernameController.text.isEmpty) _usernameController.text = data['username'] ?? '';
            if (_phoneController.text.isEmpty) _phoneController.text = data['phone'] ?? '';
          }
          
          _emailController.text = user?.email ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Account Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white10, height: 30),
                      
                      // FORM KOLOM INPUT
                      _buildFormInput("Username", _usernameController),
                      _buildFormInput("Email", _emailController, enabled: false), // Email tidak bisa diedit
                      _buildFormInput("No Telepon", _phoneController),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _showPasswordDialog,
                          child: Text("Ganti Password?", style: TextStyle(color: primaryColor)),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Tombol Update & Delete
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _isUpdating ? null : _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 14)
                              ),
                              child: _isUpdating 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Update Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showDeleteConfirm(),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
                              child: const Text('Delete', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: const Text("Logout", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget untuk baris input form
  Widget _buildFormInput(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(color: enabled ? Colors.white : Colors.grey),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPopupTextField(TextEditingController controller, String hint, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackgroundColor,
        title: const Text('Hapus Akun?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
              await user!.delete();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}