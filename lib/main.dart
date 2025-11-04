import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ============================ PAGES ============================
import 'pages/LoginPage.dart';
import 'pages/RegisterPage.dart';
import 'pages/AccountsPage.dart';
import 'pages/BlogPage.dart';
import 'pages/MarketplacePage.dart';
import 'pages/DonationPage.dart';
import 'pages/HomePage.dart';
// ============================ END ============================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReTide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF63CFC0)),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      // ============================ END ============================

      body: Stack(
        fit: StackFit.expand,
        children: [
          // ============================ Background ============================
          Image.asset(
            'assets/images/jordan-mcqueen-u9tAl8WR3DI-unsplash.jpg',
            fit: BoxFit.cover,
          ),
          // ============================ END ============================

          // ============================ Gradient Atas ============================
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(
                    colorSpace: ColorSpace.sRGB,
                    alpha: 0.6,
                  ),
                  Colors.black.withValues(
                    colorSpace: ColorSpace.sRGB,
                    alpha: 0.3,
                  ),
                ],
              ),
            ),
          ),
          // ============================ END ============================

          // ============================ Welcome Text ============================
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to ReTide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // ============================ END ============================

                // ============================ Motto ============================
                Text(
                  'Fuel the Mission. Empower the Impact.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 32.0),
                // ============================ END ============================

                // ============================ Call To Action ============================
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },

                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  label: const Text(
                    "Start",
                    style: TextStyle(
                      color:  Colors.black,
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
        ],
      ),
    );
  }
}
