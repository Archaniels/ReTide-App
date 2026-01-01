# ReTide App - Dokumentasi API

## Ringkasan

ReTide menggunakan **Firebase Backend-as-a-Service (BaaS)** untuk menangani autentikasi, operasi database, dan sinkronisasi data real-time. Dokumen ini menjelaskan semua interaksi API antara aplikasi mobile Flutter dan layanan Firebase.

---

## Daftar Isi

1. [Layanan Firebase yang Digunakan](#layanan-firebase-yang-digunakan)
2. [API Autentikasi](#api-autentikasi)
3. [API Database Firestore](#api-database-firestore)
4. [Model Data](#model-data)
5. [Aturan Keamanan](#aturan-keamanan)

---

## Layanan Firebase yang Digunakan

### 1. Firebase Authentication

- **Tujuan**: Autentikasi pengguna dan manajemen sesi
- **Versi**: `firebase_auth: ^6.1.2`
- **Metode Autentikasi**: Email/Password

### 2. Cloud Firestore

- **Tujuan**: Database NoSQL untuk menyimpan data pengguna, produk, blog post, dan donasi
- **Versi**: `cloud_firestore: ^6.1.0`
- **Tipe**: Database real-time dengan dukungan offline

### 3. Firebase Core

- **Tujuan**: Inisialisasi SDK inti Firebase
- **Versi**: `firebase_core: ^4.2.1`

---

## API Autentikasi

### Konfigurasi Dasar

```dart
// Inisialisasi Firebase
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
);
```

### 1. Registrasi Pengguna

**Endpoint**: `FirebaseAuth.instance.createUserWithEmailAndPassword()`

**Metode**: POST (ditangani oleh Firebase SDK)

**Parameter Request**:

```dart
{
  "email": "string",      // Alamat email pengguna
  "password": "string"    // Password pengguna (minimal 6 karakter)
}
```

**Implementasi**:

```dart
UserCredential userCredential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
```

**Response**: Mengembalikan objek `UserCredential` yang berisi:

- `user.uid`: Identifier unik pengguna
- `user.email`: Alamat email pengguna

**Aksi Tambahan**: Membuat profil pengguna di Firestore:

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
      'username': autoUsername,
      'email': email,
      'phone': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
```

---

### 2. Login Pengguna

**Endpoint**: `FirebaseAuth.instance.signInWithEmailAndPassword()`

**Metode**: POST (ditangani oleh Firebase SDK)

**Parameter Request**:

```dart
{
  "email": "string",
  "password": "string"
}
```

**Implementasi**:

```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

**Response**: Mengembalikan objek `UserCredential`

**Kode Error**:

- `user-not-found`: Tidak ada pengguna dengan email ini
- `wrong-password`: Password salah
- `invalid-email`: Format email tidak valid

---

### 3. Logout Pengguna

**Endpoint**: `FirebaseAuth.instance.signOut()`

**Metode**: POST (ditangani oleh Firebase SDK)

**Implementasi**:

```dart
await FirebaseAuth.instance.signOut();
```

---

### 4. Mendapatkan Pengguna Saat Ini

**Endpoint**: `FirebaseAuth.instance.currentUser`

**Metode**: GET (sinkron)

**Implementasi**:

```dart
User? user = FirebaseAuth.instance.currentUser;
```

**Response**: Mengembalikan objek `User` atau `null` jika tidak terautentikasi

---

### 5. Update Password

**Endpoint**: `user.updatePassword()`

**Prasyarat**: Pengguna harus melakukan autentikasi ulang terlebih dahulu

**Implementasi**:

```dart
// Langkah 1: Autentikasi ulang
AuthCredential credential = EmailAuthProvider.credential(
  email: user.email!,
  password: oldPassword,
);
await user.reauthenticateWithCredential(credential);

// Langkah 2: Update password
await user.updatePassword(newPassword);
```

---

### 6. Hapus Akun

**Endpoint**: `user.delete()`

**Implementasi**:

```dart
// Hapus data Firestore terlebih dahulu
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .delete();

// Kemudian hapus akun autentikasi
await user.delete();
```

---

## API Database Firestore

### Struktur Database

```
retide-6fb42 (Proyek Firebase)
└── Firestore Database
    ├── users/
    │   └── {userId}/
    │       ├── username: string
    │       ├── email: string
    │       ├── phone: string
    │       ├── createdAt: timestamp
    │       ├── donations/ (subkoleksi)
    │       │   └── {donationId}/
    │       │       ├── donationType: string
    │       │       ├── amount: number
    │       │       ├── frequency: string
    │       │       ├── status: string
    │       │       └── createdAt: timestamp
    │       └── purchases/ (subkoleksi)
    │           └── {purchaseId}/
    │               ├── productName: string
    │               ├── productPrice: string
    │               ├── productSeller: string
    │               ├── productCategory: string
    │               ├── productImage: string
    │               ├── quantity: number
    │               └── purchaseDate: timestamp
    ├── blogPosts/
    │   └── {postId}/
    │       ├── title: string
    │       ├── content: string
    │       ├── author: string
    │       ├── category: string
    │       ├── readTime: string
    │       ├── image: string
    │       └── date: timestamp
    └── marketplaceProducts/
        └── {productId}/
            ├── productName: string
            ├── productPrice: string
            ├── productSeller: string
            ├── productCategory: string
            ├── productImage: string
            └── date: timestamp
```

---

## Operasi Profil Pengguna

### 1. Mendapatkan Profil Pengguna

**Koleksi**: `users`

**Metode**: Stream Real-time

**Implementasi**:

```dart
Stream<DocumentSnapshot> getUserProfile(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots();
}
```

**Struktur Response**:

```json
{
  "username": "string",
  "email": "string",
  "phone": "string",
  "createdAt": "timestamp"
}
```

---

### 2. Update Profil Pengguna

**Koleksi**: `users`

**Metode**: UPDATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
      'username': newUsername,
      'phone': phone,
      'email': email,
    }, SetOptions(merge: true));
```

**Parameter Request**:

```dart
{
  "username": "string",
  "phone": "string",
  "email": "string"
}
```

---

## Operasi Donasi

### 1. Membuat Donasi

**Koleksi**: `users/{userId}/donations`

**Metode**: CREATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('donations')
    .add({
      'donationType': donationType,
      'amount': amount,
      'frequency': frequency,
      'status': 'success',
      'createdAt': FieldValue.serverTimestamp(),
    });
```

**Parameter Request**:

```dart
{
  "donationType": "string",     // contoh: "Ocean cleanup"
  "amount": "number",           // Jumlah dalam Rupiah
  "frequency": "string",        // "Monthly" atau "One time"
  "status": "string",           // "success" atau "pending"
  "createdAt": "timestamp"
}
```

---

### 2. Mendapatkan Donasi Pengguna

**Koleksi**: `users/{userId}/donations`

**Metode**: READ (Stream)

**Implementasi**:

```dart
Stream<QuerySnapshot> getUserDonations(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('donations')
      .orderBy('createdAt', descending: true)
      .snapshots();
}
```

---

## Operasi Marketplace

### 1. Membuat Produk

**Koleksi**: `marketplaceProducts`

**Metode**: CREATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('marketplaceProducts')
    .add({
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'date': Timestamp.now(),
    });
```

**Parameter Request**:

```dart
{
  "productName": "string",
  "productPrice": "string",
  "productSeller": "string",
  "productCategory": "string",    // "Baru", "Bekas Layak", "Daur Ulang"
  "productImage": "string",        // URL
  "date": "timestamp"
}
```

---

### 2. Mendapatkan Semua Produk

**Koleksi**: `marketplaceProducts`

**Metode**: READ (Stream)

**Implementasi**:

```dart
Stream<QuerySnapshot> getProducts() {
  return FirebaseFirestore.instance
      .collection('marketplaceProducts')
      .snapshots();
}
```

---

### 3. Update Produk

**Koleksi**: `marketplaceProducts`

**Metode**: UPDATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('marketplaceProducts')
    .doc(productId)
    .update({
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'date': Timestamp.now(),
    });
```

---

### 4. Hapus Produk

**Koleksi**: `marketplaceProducts`

**Metode**: DELETE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('marketplaceProducts')
    .doc(productId)
    .delete();
```

---

### 5. Membuat Catatan Pembelian

**Koleksi**: `users/{userId}/purchases`

**Metode**: CREATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('purchases')
    .add({
      'productName': productName,
      'productPrice': productPrice,
      'productSeller': productSeller,
      'productCategory': productCategory,
      'productImage': productImage,
      'quantity': quantity,
      'purchaseDate': FieldValue.serverTimestamp(),
    });
```

---

## Operasi Blog Post

### 1. Membuat Blog Post

**Koleksi**: `blogPosts`

**Metode**: CREATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('blogPosts')
    .add({
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'readTime': readTime,
      'image': image,
      'date': Timestamp.now(),
    });
```

**Parameter Request**:

```dart
{
  "title": "string",
  "content": "string",
  "author": "string",
  "category": "string",           // "Environment", "Impact", "Education", dll.
  "readTime": "string",          // contoh: "5 min"
  "image": "string",             // Path asset atau URL
  "date": "timestamp"
}
```

---

### 2. Mendapatkan Semua Blog Post

**Koleksi**: `blogPosts`

**Metode**: READ (Stream)

**Implementasi**:

```dart
Stream<QuerySnapshot> getBlogPosts() {
  return FirebaseFirestore.instance
      .collection('blogPosts')
      .snapshots();
}
```

---

### 3. Mendapatkan Satu Blog Post

**Koleksi**: `blogPosts`

**Metode**: READ

**Implementasi**:

```dart
Future<BlogPost?> getBlogPost(String id) async {
  final doc = await FirebaseFirestore.instance
      .collection('blogPosts')
      .doc(id)
      .get();

  if (doc.exists) {
    return BlogPost.fromFirestore(doc);
  }
  return null;
}
```

---

### 4. Update Blog Post

**Koleksi**: `blogPosts`

**Metode**: UPDATE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('blogPosts')
    .doc(postId)
    .update({
      'title': title,
      'content': content,
      'author': author,
      'category': category,
      'readTime': readTime,
      'image': image,
      'date': Timestamp.now(),
    });
```

---

### 5. Hapus Blog Post

**Koleksi**: `blogPosts`

**Metode**: DELETE

**Implementasi**:

```dart
await FirebaseFirestore.instance
    .collection('blogPosts')
    .doc(postId)
    .delete();
```

---

## Model Data

### Model User

```dart
class User {
  final String uid;
  final String email;
  final String username;
  final String phone;
  final Timestamp createdAt;
}
```

### Model Donasi

```dart
class Donation {
  final String id;
  final String donationType;
  final int amount;
  final String frequency;
  final String status;
  final Timestamp createdAt;
}
```

### Model Produk

```dart
class MarketplaceProducts {
  final String? id;
  final String productName;
  final String productPrice;
  final String productSeller;
  final String productCategory;
  final String productImage;
  final Timestamp? date;
}
```

### Model Blog Post

```dart
class BlogPost {
  final String? id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String readTime;
  final String image;
  final Timestamp? date;
}
```

### Model Pembelian

```dart
class Purchase {
  final String productName;
  final String productPrice;
  final String productSeller;
  final String productCategory;
  final String productImage;
  final int quantity;
  final Timestamp purchaseDate;
}
```

---

## Aturan Keamanan

### Aturan Keamanan Firestore yang Direkomendasikan

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Koleksi users
    match /users/{userId} {
      // Pengguna dapat membaca dan menulis data mereka sendiri
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Subkoleksi donations
      match /donations/{donationId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Subkoleksi purchases
      match /purchases/{purchaseId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Blog posts - semua orang dapat membaca, hanya pengguna terautentikasi yang dapat menulis
    match /blogPosts/{postId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Produk marketplace - semua orang dapat membaca, hanya pengguna terautentikasi yang dapat menulis
    match /marketplaceProducts/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## Penanganan Error

### Error Firebase yang Umum

#### Error Autentikasi

```dart
try {
  // Operasi autentikasi
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'weak-password':
      // Password terlalu lemah
    case 'email-already-in-use':
      // Email sudah terdaftar
    case 'user-not-found':
      // Tidak ada pengguna dengan email ini
    case 'wrong-password':
      // Password salah
    case 'invalid-email':
      // Format email tidak valid
  }
}
```

#### Error Firestore

```dart
try {
  // Operasi Firestore
} on FirebaseException catch (e) {
  print('Kode error: ${e.code}');
  print('Pesan error: ${e.message}');
}
```

---

## Batas Rate & Kuota

### Batas Firestore (Paket Gratis)

- **Pembacaan**: 50.000/hari
- **Penulisan**: 20.000/hari
- **Penghapusan**: 20.000/hari
- **Penyimpanan**: 1 GB
- **Network egress**: 10 GB/bulan

### Batas Autentikasi

- **Sign-in Email/Password**: Tidak ada batas khusus pada paket gratis
- **Operasi akun**: Tunduk pada pencegahan penyalahgunaan

---

## Waktu Respons API

### Latensi Umum

- **Autentikasi**: 200-500ms
- **Pembacaan Firestore**: 50-200ms (dengan jaringan)
- **Penulisan Firestore**: 100-300ms
- **Update Real-time**: < 100ms setelah penulisan

### Dukungan Offline

- Firestore menyediakan persistensi data offline otomatis
- Perubahan disinkronkan otomatis saat koneksi pulih

---

## Testing

### Firebase Emulator Suite

Untuk testing lokal tanpa mempengaruhi produksi:

```bash
firebase emulators:start
```

Konfigurasi di Flutter:

```dart
await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
```

---

## Konfigurasi Environment

### File Konfigurasi Firebase

- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`
- **Web**: `web/index.html` (Firebase config)
- **Dart**: `lib/firebase_options.dart`

### ID Proyek

- **Project ID**: `retide-6fb42`
- **App ID (Android)**: `1:855310351966:android:364f56a98781e53cc93ecf`
- **App ID (iOS)**: `1:855310351966:ios:5c91a656eb949855c93ecf`

---

## Sumber Daya Tambahan

- [Dokumentasi Firebase](https://firebase.google.com/docs)
- [Dokumentasi FlutterFire](https://firebase.flutter.dev/)
- [Model Data Cloud Firestore](https://firebase.google.com/docs/firestore/data-model)
- [Aturan Keamanan Firebase](https://firebase.google.com/docs/firestore/security/get-started)

---

**Terakhir Diperbarui**: Januari 2026  
**Versi**: 1.0.0  
**Dipelihara Oleh**: Tim Pengembangan ReTide
