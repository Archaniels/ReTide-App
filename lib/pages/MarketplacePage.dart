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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      extendBodyBehindAppBar: true,
      // ============================ AppBar ============================
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
        title: const Text('Marketplace', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddProductModal(context);
            },
          ),
        ],
      ),
      // ============================ END ============================

      // ============================ Drawer ============================
      endDrawer: Drawer(
        backgroundColor: Color.fromARGB(255, 17, 17, 17),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          final docs = snapshot.data?.docs ?? [];

          // Filter products based on selected condition
          List<MarketplaceProducts> allProducts = docs
              .map(
                (doc) => MarketplaceProducts.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList();

          List<MarketplaceProducts> filteredProducts = allProducts;
          if (_selectedCondition != 'Semua') {
            filteredProducts = allProducts
                .where(
                  (product) => product.productCategory == _selectedCondition,
                )
                .toList();
          }

          return SafeArea(
            child: Container(
              color: Color.fromARGB(255, 17, 17, 17),
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

                  // ============================ Product Grid ============================
                  Expanded(
                    child: filteredProducts.isEmpty
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
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.65,
                                  ),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return _buildProductCard(product);
                              },
                            ),
                          ),
                  ),
                  // ============================ END ============================
                ],
              ),
            ),
          );
        },
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
  Widget _buildProductCard(MarketplaceProducts product) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================ Product image with edit/delete buttons ============================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  product.productImage,
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
                    color: _getConditionColor(product.productCategory),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.productCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Edit button at top left
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    onPressed: () {
                      _showEditProductModal(context, product);
                    },
                  ),
                ),
              ),
              // Delete button near top
              Positioned(
                top: 8,
                left: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      _deleteProduct(product.id!);
                    },
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
                    product.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Product seller
                  Text(
                    'by ${product.productSeller}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Product price
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(int.tryParse(product.productPrice) ?? 0),
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
                        // Create a temporary cart item with all required attributes
                        Map<String, dynamic> cartItem = {
                          'productName': product.productName,
                          'productPrice': product.productPrice,
                          'productSeller': product.productSeller,
                          'productCategory': product.productCategory,
                          'productImage': product.productImage,
                        };
                        setState(() {
                          _cart.add(cartItem);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.productName} ditambahkan ke keranjang!',
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

  // Helper function to get condition color
  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'Baru':
        return Colors.green;
      case 'Bekas Layak':
        return Colors.orange;
      case 'Daur Ulang':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Show add product modal bottom sheet
  void _showAddProductModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController sellerController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tambah Produk Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Form fields
              _buildTextField(
                nameController,
                'Nama Produk',
                'Contoh: Jaket Bekas',
              ),
              _buildTextField(priceController, 'Harga', 'Contoh: 50000'),
              _buildTextField(sellerController, 'Nama Penjual', 'Contoh: Budi'),
              _buildCategoryField(categoryController),
              _buildTextField(
                imageController,
                'URL Gambar',
                'Contoh: https://...',
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63CFC0),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      sellerController.text.isNotEmpty &&
                      categoryController.text.isNotEmpty &&
                      imageController.text.isNotEmpty) {
                    if (mounted) {
                      await firestoreService.addProduct(
                        nameController.text,
                        priceController.text,
                        sellerController.text,
                        categoryController.text,
                        imageController.text,
                      );
                      if (mounted) {
                        Navigator.of(context).pop(); // Close modal
                      }
                    }
                  } else {
                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi semua field'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Tambah Produk',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Show edit product modal bottom sheet
  void _showEditProductModal(
    BuildContext context,
    MarketplaceProducts product,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: product.productName,
    );
    final TextEditingController priceController = TextEditingController(
      text: product.productPrice,
    );
    final TextEditingController sellerController = TextEditingController(
      text: product.productSeller,
    );
    final TextEditingController categoryController = TextEditingController(
      text: product.productCategory,
    );
    final TextEditingController imageController = TextEditingController(
      text: product.productImage,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Edit Produk',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Form fields
              _buildTextField(
                nameController,
                'Nama Produk',
                'Contoh: Jaket Bekas',
              ),
              _buildTextField(priceController, 'Harga', 'Contoh: 50000'),
              _buildTextField(sellerController, 'Nama Penjual', 'Contoh: Budi'),
              _buildCategoryField(categoryController),
              _buildTextField(
                imageController,
                'URL Gambar',
                'Contoh: https://...',
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63CFC0),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      sellerController.text.isNotEmpty &&
                      categoryController.text.isNotEmpty &&
                      imageController.text.isNotEmpty) {
                    if (mounted) {
                      await firestoreService.updateProduct(
                        product.id!,
                        nameController.text,
                        priceController.text,
                        sellerController.text,
                        categoryController.text,
                        imageController.text,
                      );
                      if (mounted) {
                        Navigator.of(context).pop(); // Close modal
                      }
                    }
                  } else {
                    // Show error message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi semua field'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Update Produk',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Delete product
  void _deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        title: const Text(
          'Hapus Produk',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus produk ini?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (mounted) {
                await firestoreService.deleteProduct(productId);
                if (mounted) {
                  Navigator.of(context).pop(); // Close dialog
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Build text field helper
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Build category field
  Widget _buildCategoryField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Kategori',
          hintText: 'Pilih kategori',
          hintStyle: TextStyle(color: Colors.grey[500]),
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: () {
          _showCategoryPicker(controller);
        },
      ),
    );
  }

  // Show category picker
  void _showCategoryPicker(TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pilih Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ..._conditions
                .where((c) => c != 'Semua')
                .map(
                  (category) => ListTile(
                    title: Text(
                      category,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      controller.text = category;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
