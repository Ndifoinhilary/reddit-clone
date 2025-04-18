import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

final firebaseUserProvider = Provider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});
final googleSignInAccountProvider = Provider<GoogleSignInAccount?>((ref) {
  final googleSignIn = ref.watch(googleSignInProvider);
  return googleSignIn.currentUser;
});
