import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // Default Theme of Application
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('ReTide', style: TextStyle(color: Colors.white)),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'ReTide',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      body: Align (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ReTide!',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
