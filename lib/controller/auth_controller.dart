// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignInInstance = GoogleSignIn();

  final Rx<User?> _fireBaseUser = Rx<User?>(null);

  Rx<User?> get firebaseUser => _fireBaseUser;

  User? get user => _auth.currentUser;

  Stream<User?> get authStatusChange => _auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    _fireBaseUser.bindStream(_auth.authStateChanges());
    _auth.authStateChanges().listen(
      (event) {
        _fireBaseUser(event);
      },
    );
  }

  Future<UserCredential?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> createAccountEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final userCred = await _googleSignInInstance.signIn();
      final googleAuth = await userCred?.authentication;

      final crde = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(crde);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignInInstance.signOut();
    } catch (e) {
      print(e);
    }
  }
}
