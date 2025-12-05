// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Sign in
//   Future<UserCredential?> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return result;
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }

//   // Register
//   Future<UserCredential?> registerWithEmailAndPassword(
//     String email,
//     String password,
//     String username,
//   ) async {
//     try {
//       // Create account
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Create profile
//       await _firestore.collection('users').doc(result.user!.uid).set({
//         'username': username,
//         'email': email,
//         'phone': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'itemsRecycled': 0,
//         'waterSaved': 0,
//         'co2Reduced': 0,
//         'totalDonated': 0,
//       });

//       return result;
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Get profile
//   Future<DocumentSnapshot> getUserProfile(String uid) async {
//     return await _firestore.collection('users').doc(uid).get();
//   }

//   // Update profile
//   Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
//     await _firestore.collection('users').doc(uid).update(data);
//   }

//   // Delete account
//   Future<void> deleteAccount() async {
//     String uid = _auth.currentUser!.uid;

//     // Delete data from Firestore
//     await _firestore.collection('users').doc(uid).delete();

//     // Delete authentication account
//     await _auth.currentUser!.delete();
//   }

//   // Handle Firebase Auth exceptions
//   String _handleAuthException(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'weak-password':
//         return 'Password terlalu lemah. Minimal 6 karakter.';
//       case 'email-already-in-use':
//         return 'Email sudah terdaftar.';
//       case 'user-not-found':
//         return 'User tidak ditemukan.';
//       case 'wrong-password':
//         return 'Password salah.';
//       case 'invalid-email':
//         return 'Format email tidak valid.';
//       case 'user-disabled':
//         return 'Akun telah dinonaktifkan.';
//       default:
//         return 'Terjadi kesalahan: ${e.message}';
//     }
//   }
// }

// mixin FirebaseAuth {}
