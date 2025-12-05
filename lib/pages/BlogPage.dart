import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retide_app/services/firestore_service.dart';
import 'package:intl/intl.dart';

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
  String? selectedCategory;

  final List<String> _kategoriPost = [
    'Environment',
    'Impact',
    'Education',
    'Lifestyle',
    'Tips',
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController readTimeController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  String? _editingBlogPostId;

  void _showAddForm({String? id}) {
    _editingBlogPostId = id;

    if (id != null) {
      _loadBlogPostForEditing(id);
    } else {
      titleController.clear();
      contentController.clear();
      authorController.clear();
      readTimeController.clear();
      imageController.clear();
      selectedCategory = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: readTimeController,
              decoration: const InputDecoration(
                labelText: 'Read Time (e.g., 5 min)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image Location or URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              validator: (initialValue) {
                if (initialValue == null || initialValue.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
              items: _kategoriPost.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (initialValue) {
                setState(() {
                  selectedCategory = initialValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _formSubmission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF63CFC0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(_editingBlogPostId != null ? "Update" : "Add"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadBlogPostForEditing(String id) async {
    try {
      final blogPost = await firestoreService.getBlogPost(id);
      if (blogPost != null && mounted) {
        setState(() {
          titleController.text = blogPost.title;
          contentController.text = blogPost.content;
          authorController.text = blogPost.author;
          readTimeController.text = blogPost.readTime;
          imageController.text = blogPost.image;
          selectedCategory = blogPost.category;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal untuk menampilkan blog posts: $e')),
        );
      }
    }
  }

  Future<void> _formSubmission() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final author = authorController.text.trim();
    final readTime = readTimeController.text.trim();
    final image = imageController.text.trim();

    if (title.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title tidak boleh kosong!')),
        );
      }
      return;
    }

    if (content.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content tidak boleh kosong!')),
        );
      }
      return;
    }

    if (author.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Author tidak boleh kosong!')),
        );
      }
      return;
    }

    if (readTime.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Read time tidak boleh kosong!')),
        );
      }
      return;
    }

    if (image.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image tidak boleh kosong!')),
        );
      }
      return;
    }

    if (selectedCategory == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category tidak boleh kosong!')),
        );
      }
      return;
    }

    try {
      if (_editingBlogPostId != null) {
        await firestoreService.updateBlogPost(
          _editingBlogPostId!,
          title,
          content,
          author,
          selectedCategory!,
          readTime,
          image,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog post berhasil diupdate!')),
          );
        }
      } else {
        await firestoreService.addBlogPost(
          title,
          content,
          author,
          selectedCategory!,
          readTime,
          image,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog post herasil ditambahkan!')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error menyimpan post: $e')));
      }
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddForm();
            },
          ),
        ],
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
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getBlogPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No blog posts available',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }

                  final blogPosts = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: blogPosts.length,
                    itemBuilder: (context, index) {
                      final blogPostData =
                          blogPosts[index].data() as Map<String, dynamic>?;
                      final blogPostId = blogPosts[index].id;

                      if (blogPostData != null) {
                        String formatDate = '-';
                        if (blogPostData['date'] != null) {
                          try {
                            // cek timestamp
                            final timestamp = blogPostData['date'] as Timestamp;
                            formatDate = DateFormat(
                              'dd, MMM yyyy',
                            ).format(timestamp.toDate());
                          } catch (e) {
                            // jika tidak bisa didapatkan timestamp
                            formatDate = '-';
                          }
                        }

                        final blogPost = {
                          'id': blogPostId,
                          'title': blogPostData['title'] ?? '',
                          'content': blogPostData['content'] ?? '',
                          'author': blogPostData['author'] ?? '',
                          'category': blogPostData['category'] ?? '',
                          'readTime': blogPostData['readTime'] ?? '',
                          'image': blogPostData['image'] ?? '',
                          'date': formatDate,
                        };

                        return BlogCardBuild(
                          blogPost: blogPost,
                          onEdit: () => _showAddForm(id: blogPostId),
                          onDelete: () async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                  'Apakah anda yakin ingin menghapus blog post ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await firestoreService.deleteBlogPost(
                                  blogPostId,
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Blog post berhasil dihapus!',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error dalam menghapus blog post: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
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
  Widget BlogCardBuild({
    required Map<String, dynamic> blogPost,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 28),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================ Blog Image ============================
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              blogPost['image'],
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
                    blogPost['category'],
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
                  blogPost['title'],
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
                  blogPost['content'],
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
                      blogPost['author'],
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
                      blogPost['date'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      blogPost['readTime'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),

                // ============================ END ============================
                const SizedBox(height: 12),

                // ============================ Action Buttons ====================
                Row(
                  children: [
                    // Read More Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening: ${blogPost['title']}'),
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
                    const SizedBox(width: 8),

                    // Edit Button
                    if (onEdit != null)
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFF63CFC0),
                          size: 20,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            28,
                            28,
                            28,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: const Color(0xFF63CFC0),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                    // Delete Button
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            28,
                            28,
                            28,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),
                  ],
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
