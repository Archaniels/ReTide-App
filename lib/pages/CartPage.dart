import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'BlogPage.dart';
import 'HomePage.dart';
import 'DonationPage.dart';
import 'CartPage.dart';
// ============================ END ============================

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================ AppBar ============================
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text('Cart', style: TextStyle(color: Colors.white)),
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
      
      backgroundColor: Colors.black,
      
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Card(
                  color: const Color.fromARGB(255, 28, 28, 28),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    title: Text(product['name'],
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      '${product['price']}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                );
              },
            ),      
    );
  }
}
