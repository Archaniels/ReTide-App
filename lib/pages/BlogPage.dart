import 'package:flutter/material.dart';
// ============================ FIREBASE ============================
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retide_app/firebase_options.dart';
import 'package:retide_app/firestore_service.dart';
// ============================ END ============================
// ============================ PAGES ============================
import 'AccountsPage.dart';
import 'MarketplacePage.dart';
import 'DonationPage.dart';
import 'HomePage.dart';
// ============================ END ============================

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // ============================ Blog Posts Data ============================
  final List<Map<String, dynamic>> _blogPosts = [
    {
      'title': 'From the Depths of the Sea',
      'content':
          'A global investigation into the growing ocean plastic crisis, this documentary tracks how waste travels from our streets to the seas, devastating marine ecosystems and endangering food chains.',
      'author': 'Admin',
      'date': 'Nov 1, 2025',
      'category': 'Environment',
      'readTime': '5 min',
      'image': 'assets/images/blog/fromthedepthsofthesea.png',
    },
    {
      'title': 'Dark Blue',
      'content':
          'A global investigation into the growing ocean plastic crisis, this documentary tracks how waste travels from our streets to the seas, devastating marine ecosystems and endangering food chains.',
      'author': 'Admin',
      'date': 'Oct 25, 2025',
      'category': 'Impact',
      'readTime': '6 min',
      'image': 'assets/images/blog/darkblue.png',
    },
    {
      'title': 'Sea of Debris',
      'content':
          'A global investigation into the growing ocean plastic crisis, this documentary tracks how waste travels from our streets to the seas, devastating marine ecosystems and endangering food chains.',
      'author': 'Admin',
      'date': 'Oct 20, 2025',
      'category': 'Education',
      'readTime': '8 min',
      'image': 'assets/images/blog/seaofdebris.png',
    },
    {
      'title': 'Ghost Nets',
      'content':
          'A global investigation into the growing ocean plastic crisis, this documentary tracks how waste travels from our streets to the seas, devastating marine ecosystems and endangering food chains.',
      'author': 'Admin',
      'date': 'Oct 15, 2025',
      'category': 'Lifestyle',
      'readTime': '5 min',
      'image': 'assets/images/blog/ghostnets.png',
    },
    {
      'title': 'The Blue Wound',
      'content':
          'A global investigation into the growing ocean plastic crisis, this documentary tracks how waste travels from our streets to the seas, devastating marine ecosystems and endangering food chains.',
      'author': 'Admin',
      'date': 'Oct 10, 2025',
      'category': 'Tips',
      'readTime': '7 min',
      'image': 'assets/images/blog/thebluewound.png',
    },
  ];
  // ============================ END ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // ============================ AppBar ============================
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Blog', style: TextStyle(color: Colors.white)),
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
      body: SafeArea(
        child: Column(
          children: [
            // ============================ Header Section ============================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sustainability Blog',
                    style: TextStyle(
                      color: Color(0xFF63CFC0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stories, tips, and insights for a greener future',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
            // ============================ END ============================

            // ============================ Blog Posts List ============================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _blogPosts.length,
                itemBuilder: (context, index) {
                  final post = _blogPosts[index];
                  return BlogCardBuild(post);
                },
              ),
            ),
            // ============================ END ============================
          ],
        ),
      ),
    );
  }

  // ============================ Drawer Item Helper ============================
  Widget _drawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
  // ============================ END ============================

  // ============================ Blog Card Builder ============================
  Widget BlogCardBuild(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================ Blog Image ============================
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              post['image'],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // ============================ END ============================

          // ============================ Blog Content ============================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF63CFC0).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    post['category'],
                    style: const TextStyle(
                      color: Color(0xFF63CFC0),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ============================ Title ============================
                Text(
                  post['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // ============================ END ============================

                // ============================ content ============================
                Text(
                  post['content'],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                // ============================ END ============================

                // ============================ Info ============================
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post['author'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post['date'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      post['readTime'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),

                // ============================ END ============================
                const SizedBox(height: 12),

                // ============================ Read More ============================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening: ${post['title']}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF63CFC0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // ============================ END ============================
              ],
            ),
          ),
          // ============================ END ============================
        ],
      ),
    );
  }

  // ============================ END ============================
}
