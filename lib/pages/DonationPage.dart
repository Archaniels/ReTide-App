import 'dart:ui';
import 'package:flutter/material.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'MarketplacePage.dart';
import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// ============================ END ============================

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String? selectedDonationType;
  String? selectedAmount;
  String? selectedFrequency = 'Monthly';

  final Map<String, String> donationDescriptions = {
    "Cost of education":
        "Mendukung biaya pendidikan bagi anak-anak dan pemuda untuk masa depan yang lebih cerah.",
    "Environmental protection":
        "Berfokus pada perlindungan ekosistem, mencegah kerusakan lingkungan, dan menjaga keseimbangan alam.",
    "Ocean cleanup":
        "Mendanai kegiatan pembersihan lautan, pengumpulan sampah plastik, dan pelestarian habitat laut.",
  };

  final customAmountController = TextEditingController();
  final FocusNode customAmountFocus = FocusNode();
  String? amountErrorText;

  @override
  void initState() {
    super.initState();

    debugPrint("UID LOGIN: ${FirebaseAuth.instance.currentUser?.uid}");
    debugPrint("EMAIL LOGIN: ${FirebaseAuth.instance.currentUser?.email}");

    customAmountFocus.addListener(() {
      if (customAmountFocus.hasFocus) {
        setState(() {
          selectedAmount = null;
        });
      }
    });
  }

  @override
  void dispose() {
    customAmountFocus.dispose();
    customAmountController.dispose();
    super.dispose();
  }

  Future<void> saveDonationToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // Tentukan nominal
    int amount;
    if (customAmountController.text.isNotEmpty) {
      amount = int.tryParse(customAmountController.text) ?? 0;
    } else {
      amount = int.parse(selectedAmount!.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('donations')
        .add({
          'donationType': selectedDonationType,
          'amount': amount,
          'frequency': selectedFrequency,
          'status': 'success',
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Pembayaran Berhasil"),
        content: const Text(
          "Terima kasih telah berdonasi 🌱\nDonasi kamu sangat berarti.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Donation', style: TextStyle(color: Colors.white)),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'ReTide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _drawerItem('Home', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _drawerItem('Marketplace', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MarketplacePage()),
              );
            }),
            _drawerItem('Donations', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonationPage()),
              );
            }),
            _drawerItem('Account', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountsPage()),
              );
            }),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/donationbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'We Can Save\nThe Future.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Choose a donation type',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),

                            // ICON INFO
                            GestureDetector(
                              onTap: () {
                                _showDonationInfo(context);
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: selectedDonationType,
                          dropdownColor: const Color(
                            0xFF1A1A1A,
                          ), // warna background dropdown list
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white70,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Select donation type',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor:
                                Colors.black54, // sama seperti custom amount
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),

                            // Border normal
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white30,
                                width: 1,
                              ),
                            ),

                            // Border saat fokus (tidak biru)
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white70,
                                width: 1.2,
                              ),
                            ),

                            // Border default
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),

                          items:
                              [
                                'Cost of education',
                                'Environmental protection',
                                'Ocean cleanup',
                              ].map((String label) {
                                return DropdownMenuItem<String>(
                                  value: label,
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),

                          onChanged: (String? value) {
                            setState(() {
                              selectedDonationType = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Choose a donation amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: ['Rp25.000', 'Rp50.000', 'Rp100.000'].map((
                            String amount,
                          ) {
                            return ChoiceChip(
                              label: Text(
                                amount,
                                style: TextStyle(
                                  color: selectedAmount == amount
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: selectedAmount == amount,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedAmount = selected ? amount : null;
                                  customAmountController.clear();
                                  customAmountFocus.unfocus();
                                });
                              },
                              backgroundColor: Colors.black45,
                              selectedColor: Colors.tealAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: Colors.white24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: customAmountController,
                              focusNode: customAmountFocus,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    amountErrorText = null;
                                    return;
                                  }

                                  final amount = int.tryParse(value) ?? 0;

                                  if (amount < 5000) {
                                    amountErrorText =
                                        "Minimum donation is Rp5.000";
                                  } else {
                                    amountErrorText = null;
                                    selectedAmount = value;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter a custom amount',
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                filled: true,
                                fillColor: Colors.black38,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white30,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.tealAccent,
                                  ),
                                ),
                              ),
                            ),

                            if (amountErrorText != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                amountErrorText!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          'Choose a donation frequency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            _buildRadioOption('Monthly'),
                            const SizedBox(width: 14),
                            _buildRadioOption('One time'),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(color: Colors.white70),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final amount =
                                      int.tryParse(
                                        customAmountController.text,
                                      ) ??
                                      0;

                                  // Validasi custom amount
                                  if (customAmountController.text.isNotEmpty &&
                                      amount < 5000) {
                                    setState(() {
                                      amountErrorText =
                                          "Minimum donation is Rp5.000";
                                    });
                                    return;
                                  }

                                  // Validasi preset atau custom
                                  if (selectedAmount == null &&
                                      customAmountController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Silakan pilih atau isi nominal donasi",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await saveDonationToFirestore();
                                  showSuccessDialog();
                                },

                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Riwayat Donasi Kamu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('donations')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text(
                                "Belum ada donasi.",
                                style: TextStyle(color: Colors.white70),
                              );
                            }

                            return Column(
                              children: snapshot.data!.docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.volunteer_activism,
                                          color: Colors.tealAccent,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['donationType'],
                                                style: const TextStyle(
                                                  color: Colors.tealAccent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Rp ${data['amount']}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(
                                                  (data['createdAt']
                                                          as Timestamp)
                                                      .toDate(),
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================ Drawer helper ============================
  Widget _drawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
  // ============================ END ============================

  Widget _buildRadioOption(String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFrequency = label;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedFrequency == label
                  ? Colors.tealAccent
                  : Colors.white30,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selectedFrequency == label
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selectedFrequency == label
                    ? Colors.tealAccent
                    : Colors.white60,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Donation Type Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // List informasi
                ...donationDescriptions.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
