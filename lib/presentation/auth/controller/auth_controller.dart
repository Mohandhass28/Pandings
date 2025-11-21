// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pendings/core/router/app_routes_config.dart';
import 'package:pendings/firebase/firebase_db.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignInInstance = GoogleSignIn();

  final RxString error = "".obs;

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
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      error.value = ""; // Clear error on success
      Get.offAllNamed(RouterName.ROOT);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error('Wrong password provided for that user.');
      } else {
        error('${e.message}');
      }
    } catch (error) {
      log("$error");
    }
  }

  Future<UserCredential?> createAccountEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in Firestore
      await db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        "name": userName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      error.value = ""; // Clear error on success
      Get.offAllNamed(RouterName.ROOT); // Navigate on success
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        error('The email address is badly formatted.');
      } else {
        error('${e.message}');
      }
    } catch (error) {
      log("$error");
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final userCred = await _googleSignInInstance.signIn();
      final googleAuth = await userCred?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result = await _auth.signInWithCredential(cred);

      // Store or update user info
      final user = result.user;
      if (user != null) {
        await db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error('Wrong password provided for that user.');
      } else {
        error('${e.message}');
      }
    } catch (error) {
      log("$error");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (_googleSignInInstance.currentUser != null) {
        await _googleSignInInstance.signOut();
      }
      Get.offAllNamed(RouterName.LOGIN);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllUser() async {
    final usersSnapshot = await db.collection('users').get();

    final users = usersSnapshot.docs.map((doc) => doc.data()).toList();
  }
}
