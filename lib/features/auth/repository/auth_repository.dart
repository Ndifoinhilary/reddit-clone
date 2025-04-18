import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/user_models.dart';


final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : _firestore = firestore,
       _auth = auth,
       _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  
  Stream<User?> get user => _auth.authStateChanges();

  FutureEither<UserModels> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = (await googleUser?.authentication);
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      late UserModels userModels;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModels = UserModels(
          name: userCredential.user!.displayName ?? 'No name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModels.toMap());
      } else {
        userModels = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModels);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Stream<UserModels> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModels.fromMap(event.data() as Map<String, dynamic>);
    });
  }
}
