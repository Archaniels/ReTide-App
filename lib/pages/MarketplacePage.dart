import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ============================ FIREBASE ============================
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retide_app/services/firebase_options.dart';
import 'package:retide_app/services/firestore_service.dart';
// ============================ END ============================
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
  final FirestoreService firestoreService = FirestoreService();

  // ============================ Filter State ============================
  String _selectedCondition = 'Semua'; // Default: tampilkan semua
  final List<String> _conditions = [
    'Semua',
    'Baru',
    'Bekas Layak',
    'Daur Ulang',
  ];
  // ============================ END ============================

  // ============================ Product List (dengan kondisi) ============================
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Eco Tote Bag',
      'price': 150000,
      'image': 'assets/images/website_Webstore_r1.jpg',
      'condition': 'Baru',
      'description': 'Tas ramah lingkungan dari bahan daur ulang',
    },
    {
      'name': 'Reusable Bottle',
      'price': 100000,
      'image':
          'assets/images/Dangers-Of-Not-Cleaning-Your-Reusable-Water-Bottlejpg.webp',
      'condition': 'Baru',
      'description': 'Botol minum stainless steel premium',
    },
    {
      'name': 'Bamboo Toothbrush',
      'price': 20000,
      'image': 'assets/images/bamboo-toothbrushes-for-better-oral-health.png',
      'condition': 'Baru',
      'description': 'Sikat gigi bambu biodegradable',
    },
    {
      'name': 'Organic Cotton Shirt',
      'price': 30000,
      'image':
          'assets/images/RECOVER_OG100_ORGANICSHORTSLEEVETSHIRT_BLACK_FRONT_2048x2048.webp',
      'condition': 'Bekas Layak',
      'description': 'Kaos katun organik kondisi sangat baik',
    },
    {
      'name': 'Recycled Notebook',
      'price': 30000,
      'image': 'assets/images/notebook-cardboard_paper.webp',
      'condition': 'Daur Ulang',
      'description': 'Buku catatan dari kertas daur ulang',
    },
    {
      'name': 'Sustainable Sneakers',
      'price': 555000,
      'image': 'assets/images/adidas_parley_6.webp',
      'condition': 'Baru',
      'description': 'Sepatu dari sampah plastik laut',
    },
    {
      'name': 'Upcycled Denim Jacket',
      'price': 250000,
      'image': 'assets/images/IMG_20230320_143001_520.jpg',
      'condition': 'Daur Ulang',
      'description': 'Jaket denim dari pakaian bekas',
    },
    {
      'name': 'Glass Food Container',
      'price': 75000,
      'image':
          'assets/images/93594_KSP_Divided_Glass_600ml_Storage_Container__Clear_White.webp',
      'condition': 'Bekas Layak',
      'description': 'Wadah makanan kaca, kondisi mulus',
    },
  ];
  // ============================ END ============================

  // ============================ Get Filtered Products ============================
  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCondition == 'Semua') {
      return _allProducts;
    }
    return _allProducts
        .where((product) => product['condition'] == _selectedCondition)
        .toList();
  }
  // ============================ END ============================

  // ============================ Get Condition Color ============================
  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'Baru':
        return const Color(0xFF4CAF50); // Hijau
      case 'Bekas Layak':
        return const Color(0xFFFF9800); // Oranye
      case 'Daur Ulang':
        return const Color(0xFF2196F3); // Biru
      default:
        return Colors.grey;
    }
  }
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
          ],
        ),
      ),

      // ============================ END ============================
      body: 
      // StreamBuilder(
      //   stream: firestoreService.getUsers(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasError) {
      //       return const Center(child: Text('Terjadi kesalahan'));
      //     }
      //     final docs = snapshot.data?.docs ?? [];
      //     if (docs.isEmpty) {
      //       return const Center(child: Text('Tidak ada data'));
      //     }

          SafeArea(
            child: Container(
              color: Colors.black,
              child: Column(
                children: [
                  // ============================ Header ============================
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Explore Products",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
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
                            if (_cart.isNotEmpty)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF63CFC0),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${_cart.length}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ============================ END ============================

                  // ============================ Filter Section ============================
                  Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _conditions.length,
                      itemBuilder: (context, index) {
                        final condition = _conditions[index];
                        final isSelected = _selectedCondition == condition;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(
                              condition,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCondition = condition;
                              });
                            },
                            backgroundColor: const Color.fromARGB(
                              255,
                              28,
                              28,
                              28,
                            ),
                            selectedColor: const Color(0xFF63CFC0),
                            checkmarkColor: Colors.black,
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF63CFC0)
                                  : Colors.white24,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ============================ END ============================
                  const SizedBox(height: 16),

                  // ============================ Product Count ============================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_filteredProducts.length} Produk Tersedia',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ============================ END ============================

                  // ============================ Product Grid ============================
                  Expanded(
                    child: _filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada produk dengan kondisi ini',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: GridView.builder(
                              itemCount: _filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.65,
                                  ),
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return _buildProductCard(product);
                              },
                            ),
                          ),
                  ),
                  // ============================ END ============================
                ],
              ),
            ),
          )
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
          // ============================ Product image with condition badge ============================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  product['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getConditionColor(product['condition']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product['condition'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ============================ END ============================

          // ============================ Product details ============================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Product description
                  if (product['description'] != null)
                    Text(
                      product['description'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const Spacer(),

                  // Product price
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(product['price']),
                    style: const TextStyle(
                      color: Color(0xFF63CFC0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Add to cart button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Color(0xFF63CFC0),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        setState(() {
                          _cart.add(product);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product['name']} ditambahkan ke keranjang!',
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF63CFC0),
                          ),
                        );
                      },
                      child: const Text(
                        'Tambah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ============================ END ============================
        ],
      ),
    );
  }

  // ============================ END ============================
}
