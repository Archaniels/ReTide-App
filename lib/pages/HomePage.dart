import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'BlogPage.dart';
import 'MarketplacePage.dart';
import 'DonationPage.dart';
// ============================ END ============================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<Map<String, dynamic>> _getImpactData() {
    if (currentUser == null) {
      return Stream.value({
        'itemsRecycled': 0,
        'waterSaved': 0,
        'co2Reduced': 0,
        'totalDonated': 0,
      });
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .snapshots()
        .asyncMap((userDoc) async {
          final donationsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .collection('donations')
              .get();

          int totalDonated = 0;
          for (var doc in donationsSnapshot.docs) {
            final data = doc.data();
            totalDonated += (data['amount'] as int?) ?? 0;
          }

          final purchasesSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .collection('purchases')
              .get();

          int itemsRecycled = purchasesSnapshot.docs.length;

          double waterSaved = itemsRecycled * 6.5;
          double co2Reduced = itemsRecycled * 0.5;

          return {
            'itemsRecycled': itemsRecycled,
            'waterSaved': waterSaved,
            'co2Reduced': co2Reduced,
            'totalDonated': totalDonated,
          };
        });
  }

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

      // ============================ Hamburger Menu ============================
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

      // ============================ END ============================
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ============================ Homepage Card ============================
            Align(
              alignment: Alignment(20.0, -0.9),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/jordan-mcqueen-u9tAl8WR3DI-unsplash.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),

            // ============================ END ============================
            const SizedBox(height: 24),

            // ============================ Feature Widget ============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 17, 17, 17),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FeatureButton(
                      context,
                      icon: Icons.favorite,
                      label: 'Donation',
                      page: DonationPage(),
                    ),
                    FeatureButton(
                      context,
                      icon: Icons.storefront,
                      label: 'Marketplace',
                      page: const MarketplacePage(),
                    ),
                    FeatureButton(
                      context,
                      icon: Icons.person,
                      label: 'Account',
                      page: const AccountsPage(),
                    ),
                    FeatureButton(
                      context,
                      icon: Icons.article,
                      label: 'Blog',
                      page: const BlogPage(),
                    ),
                  ],
                ),
              ),
            ),

            // ============================ END ============================
            const SizedBox(height: 24),

            // ============================ Impact Dashboard ============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Impact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  StreamBuilder<Map<String, dynamic>>(
                    stream: _getImpactData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF63CFC0),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading impact data',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final data =
                          snapshot.data ??
                          {
                            'itemsRecycled': 0,
                            'waterSaved': 0.0,
                            'co2Reduced': 0.0,
                            'totalDonated': 0,
                          };

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ImpactCardBuilder(
                                  icon: Icons.eco,
                                  value: '${data['itemsRecycled']}',
                                  label: 'Items Recycled',
                                  color: Color(0xFF63CFC0),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ImpactCardBuilder(
                                  icon: Icons.water_drop,
                                  value:
                                      '${data['waterSaved'].toStringAsFixed(1)}L',
                                  label: 'Water Saved',
                                  color: Color(0xFF4A9FE8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ImpactCardBuilder(
                                  icon: Icons.co2,
                                  value:
                                      '${data['co2Reduced'].toStringAsFixed(1)}kg',
                                  label: 'CO₂ Reduced',
                                  color: Color(0xFF7CB342),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ImpactCardBuilder(
                                  icon: Icons.volunteer_activism,
                                  value: NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(data['totalDonated']),
                                  label: 'Donated',
                                  color: Color(0xFFFF6B6B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // ============================ END ============================
            const SizedBox(height: 24),
          ],
        ),
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

  // ============================ Impact Card Builder ============================
  Widget ImpactCardBuilder({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
  // ============================ END ============================

  // ============================ Reusable Feature Widget ============================
  Widget FeatureButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xFF63CFC0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
