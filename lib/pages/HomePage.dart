import 'dart:ui';

import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================ AppBar ============================
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text('ReTide', style: TextStyle(color: Colors.white)),
      ),
      // ============================ END ============================

      // ============================ Hamburger Menu ============================
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            DrawerHeader(
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
          ],
        ),
      ),

      // ============================ END ============================
      body: Column(
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
                color: Colors.black,
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

        ],
      ),
    );
  }

  // ============================ Reusable Feature Widget ============================
  Widget FeatureButton(
    BuildContext context, {
      required IconData icon,
      required String label,
      required Widget page,
    }
  ){
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
