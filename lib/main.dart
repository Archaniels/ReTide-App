import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retide_app/services/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ============================ PAGES ============================
import 'pages/LoginPage.dart';
import 'pages/RegisterPage.dart';
import 'pages/AccountsPage.dart';
import 'pages/BlogPage.dart';
import 'pages/MarketplacePage.dart';
import 'pages/DonationPage.dart';
import 'pages/HomePage.dart';
// ============================ END ============================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // sesuaikan UI design kamu
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ReTide',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF63CFC0)),
            textTheme: GoogleFonts.poppinsTextTheme(),
            scaffoldBackgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          home: child,
        );
      },
      child: const MyHomePage(),
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0),
                  //   child: Image.asset(
                  //     'assets/ReTide_Logo.png',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Fuel the Mission. Empower the Impact.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "Selamatkan lautan kita, hanya dengan sentuhan jari.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                  ),
                  SizedBox(height: 25.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LoginPage();
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(300.0),
                      height: ScreenUtil().setHeight(50.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color(0xFF63CFC0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    child: Text(
                      'Create an Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return RegisterPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text(
            //       'Welcome to ReTide',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 28,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     SizedBox(height: 16),
            //     // ============================ END ============================

            //     // ============================ Motto ============================
            //     Text(
            //       'Fuel the Mission. Empower the Impact.',
            //       style: TextStyle(color: Colors.white, fontSize: 18),
            //     ),
            //     const SizedBox(height: 32.0),
            //     // ============================ END ============================

            //     // ============================ Call To Action ============================
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const LoginPage(),
            //           ),
            //         );
            //       },

            //       icon: const Icon(Icons.arrow_forward, color: Colors.black),
            //       label: const Text(
            //         "Start",
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),

            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.white,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 24,
            //           vertical: 14,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //       ),
            //     ),
            //     // ============================ END ============================
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
