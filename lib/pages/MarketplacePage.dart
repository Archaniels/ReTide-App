import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'BlogPage.dart';
import 'HomePage.dart';
import 'DonationPage.dart';
import 'CartPage.dart';
// ============================ END ============================

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final List<Map<String, dynamic>> _cart = [];

  // ============================ Product List ============================
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Eco Tote Bag',
      'price': 150000,
      'image': 'assets/images/website_Webstore_r1.jpg',
    },
    {
      'name': 'Reusable Bottle',
      'price': 100000,
      'image':
          'assets/images/Dangers-Of-Not-Cleaning-Your-Reusable-Water-Bottlejpg.webp',
    },
    {
      'name': 'Bamboo Toothbrush',
      'price': 20000,
      'image': 'assets/images/bamboo-toothbrushes-for-better-oral-health.png',
    },
    {
      'name': 'Organic Cotton Shirt',
      'price': 30000,
      'image':
          'assets/images/RECOVER_OG100_ORGANICSHORTSLEEVETSHIRT_BLACK_FRONT_2048x2048.webp',
    },
    {
      'name': 'Recycled Notebook',
      'price': 30000,
      'image': 'assets/images/notebook-cardboard_paper.webp',
    },
    {
      'name': 'Sustainable Sneakers',
      'price': 555000,
      'image': 'assets/images/adidas_parley_6.webp',
    },
  ];
  // ============================ END ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // ============================ AppBar ============================
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Marketplace', style: TextStyle(color: Colors.white)),
      ),
      // ============================ END ============================

      // ============================ Drawer ============================
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
            // ============================ Navigator ============================
            _drawerItem('Home', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _drawerItem('Blog', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlogPage()),
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
            // ============================ END ============================
          ],
        ),
      ),

      // ============================ END ============================
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              // ============================ Header ============================
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartPage(cartItems: _cart),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // ============================ END ============================

              // ============================ Product Grid ============================
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: const BoxDecoration(color: Colors.black),
                  // ============================ Grid Builder ============================
                  child: GridView.builder(
                    itemCount: _products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return _buildProductCard(product);
                    },
                  ),
                  // ============================ END ============================
                ),
              ),
              // ============================ END ============================
            ],
          ),
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

  // ============================ Product card builder ============================
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================ Product image ============================
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              product['image'],
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // ============================ END ============================

          // ============================ Product name ============================
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // ============================ END ============================

          // ============================ Product price ============================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Rp${product['price']}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ============================ END ============================
          const Spacer(),

          // ============================ Add to cart button ============================
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size.fromHeight(36),
              ),
              onPressed: () {
                setState(() {
                  _cart.add(product);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['name']} added to cart!')),
                );
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // ============================ END ============================
        ],
      ),
    );
  }
}
