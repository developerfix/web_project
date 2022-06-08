import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projectx/pages/auth/authScreen.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/models/user.dart' as model;

import '../constants/style.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  bool isLoging = false;
  User? get user => _user.value;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, loginRedirect);
  }

  loginRedirect(User? user) {
    Timer(Duration(seconds: isLoging ? 0 : 2), () {
      if (user == null) {
        isLoging = false;
        update();
        Get.offAll(() => const AuthScreen());
      } else {
        isLoging = true;
        update();
        Get.offAll(() => const RecentProjects());
      }
    });
  }

  void registerUser({name, email, password}) async {
    try {
      isLoging = true;
      update();

      UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      model.User user = model.User(
          name: name,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: '',
          noOfProjects: 0);
      await firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());

      getSuccessSnackBar("Successfully logged in");
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Account Creating Failed", e);
    }
  }

  void login(email, password) async {
    try {
      isLoging = true;
      update();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      getSuccessSnackBar("Successfully logged in as ${_user.value!.email}");
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Login Failed", e);
    }
  }

  void googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    isLoging = true;
    update();
    try {
      googleSignIn.disconnect();
    } catch (e) {}
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleSignInAccount.authentication;
        final crendentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(crendentials);

        User? registereduser = userCredential.user;

        model.User user = model.User(
            name: registereduser!.displayName,
            email: registereduser.email,
            uid: registereduser.uid,
            profilePhoto: '',
            noOfProjects: 0);

        await firestore
            .collection('users')
            .doc(registereduser.uid)
            .set(user.toJson());

        getSuccessSnackBar("Successfully logged in");
      }
    } on FirebaseAuthException catch (e) {
      getErrorSnackBar("Google Login Failed", e);
    } on PlatformException catch (e) {
      getErrorSnackBar("Google Login Failed", e);
    }
  }

  void forgorPassword(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      getSuccessSnackBar("Reset mail sent successfully. Check mail!");
    } on FirebaseAuthException catch (e) {
      getErrorSnackBar("Error", e);
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
