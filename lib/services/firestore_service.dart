import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BlogPost {
  final String? id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String readTime;
  final String image;
  final Timestamp? date;

  BlogPost({
    this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.readTime,
    required this.image,
    this.date,
  });

  // Convert dokumne Firestore -> objek BlogPost
  factory BlogPost.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return BlogPost(
      id: snapshot.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      readTime: data['readTime'] ?? '',
      image: data['image'] ?? '',
      date: data['date'],
    );
  }

  // Convert objek BlogPost -> format firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'readTime': readTime,
      'image': image,
      'date': date ?? Timestamp.now(),
    };
  }
}

class MarketplaceProducts {
  final String? id;
  final String productName;
  final String productPrice;
  final String productSeller;
  final String productCategory;
  final String productImage;
  final Timestamp? date;

  MarketplaceProducts({
    this.id,
    required this.productName,
    required this.productPrice,
    required this.productSeller,
    required this.productCategory,
    required this.productImage,
    this.date,
  });

  // Convert dokumne Firestore -> objek MarketplaceProducts
  factory MarketplaceProducts.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return MarketplaceProducts(
      id: snapshot.id,
      productName: data['productName'] ?? '',
      productPrice: data['productPrice'] ?? '',
      productSeller: data['productSeller'] ?? '',
      productCategory: data['productCategory'] ?? '',
      productImage: data['productImage'] ?? '',
      date: data['date'],
    );
  }

  // Convert objek MarketplaceProducts -> format firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'date': date ?? Timestamp.now(),
    };
  }
}

class FirestoreService {
  final CollectionReference blogPosts = FirebaseFirestore.instance.collection(
    'blogPosts',
  );

  final CollectionReference marketplaceProducts = FirebaseFirestore.instance
      .collection('marketplaceProducts');

  // Blog Post CRUD
  // CREATE
  Future<void> addBlogPost(
    String title,
    String content,
    String author,
    String category,
    String readTime,
    String image,
  ) {
    return blogPosts.add({
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'readTime': readTime,
      'image': image,
      'date': Timestamp.now(),
    });
  }

  // READ - Get all blog posts
  Stream<QuerySnapshot> getBlogPosts() {
    return blogPosts.snapshots();
  }

  // READ - Get 1 blog post
  Future<BlogPost?> getBlogPost(String id) async {
    final doc = await blogPosts.doc(id).get();
    if (doc.exists) {
      return BlogPost.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );
    }
    return null;
  }

  // UPDATE - blog post
  Future<void> updateBlogPost(
    String id,
    String title,
    String content,
    String author,
    String category,
    String readTime,
    String image,
  ) {
    return blogPosts.doc(id).update({
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'readTime': readTime,
      'image': image,
      'date': Timestamp.now(),
    });
  }

  // DELETE - blog post
  Future<void> deleteBlogPost(String id) async {
    await blogPosts.doc(id).delete();
  }

  // Marketplace Page CRUD
  // CREATE
  Future<void> addProduct(
    String productName,
    String productPrice,
    String productSeller,
    String productCategory,
    String productImage,
  ) {
    return marketplaceProducts.add({
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'date': Timestamp.now(),
    });
  }

  // READ - Get all products
  Stream<QuerySnapshot> getProducts() {
    return marketplaceProducts.snapshots();
  }

  // READ - Get product by category
  Future<MarketplaceProducts?> getProductByCategory(String category) async {
    final doc = await marketplaceProducts.doc(category).get();
    if (doc.exists) {
      return MarketplaceProducts.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );
    }
    return null;
  }

  // UPDATE - product
  Future<void> updateProduct(
    String id,
    String productName,
    String productPrice,
    String productSeller,
    String productCategory,
    String productImage,
  ) {
    return marketplaceProducts.doc(id).update({
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'date': Timestamp.now(),
    });
  }

  // DELETE - product
  Future<void> deleteProduct(String id) async {
    await marketplaceProducts.doc(id).delete();
  }
}
