import 'dart:async';
import 'package:ava/controllers/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ava/pages/auth/auth_screen.dart';
import 'package:ava/models/user.dart' as model;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constants/style.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis_auth/auth_io.dart';

import '../pages/departments_grid.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  bool isLoging = false;
  User? get user => _user.value;
  final _auth = FirebaseAuth.instance;
  RxBool isDarkTheme = false.obs;

  Rx<int> isObscure = 1.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.authStateChanges());
    ever(_user, loginRedirect);
  }

  loginRedirect(var user) {
    Timer(Duration(seconds: isLoging ? 0 : 2), () {
      if (user == null) {
        isLoging = false;
        update();
        Get.offAll(() => const AuthScreen());
      } else {
        isLoging = true;
        update();
        Get.to(() => const DepartmentsGrid());
      }
    });
  }

  void registerUser({name, email, password}) async {
    try {
      isLoging = true;
      update();

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      model.User user = model.User(
          name: name,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: '',
          lastOpenedProjectId: '',
          lastOpenedDocumentId: '');
      if (!kIsWeb) {
        await firedart.Firestore.instance
            .collection('users')
            .document(cred.user!.uid)
            .set(user.toJson());
      } else {
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      }
    } on FirebaseAuthException {
      //define error
      getErrorSnackBar(
        "Account Creation Failed",
      );
    }
  }

  void login(email, password) async {
    try {
      isLoging = true;
      update();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      //define error
      getErrorSnackBar(
        "Login Failed",
      );
    }
  }

  void _lauchAuthInBrowser(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not lauch $url';
  }

  void googleLogin(BuildContext context) async {
    if (!kIsWeb) {
      isLoging = true;
      update();

      try {
        var id = ClientId(
          '69104603518-p559e135bhua3er1124roao29f3mvebj.apps.googleusercontent.com',
          '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',
        );
        var scopes = [
          'email',
          'profile',
        ];

        var client = http.Client();
        obtainAccessCredentialsViaUserConsent(
                id, scopes, client, (url) => _lauchAuthInBrowser(url))
            .then((AccessCredentials? credentials) async {
          final crendentials = GoogleAuthProvider.credential(
              accessToken: credentials?.accessToken.data);

          final UserCredential userCredential =
              await _auth.signInWithCredential(crendentials);

          User? registereduser = userCredential.user;

          model.User user = model.User(
              name: registereduser!.displayName,
              email: registereduser.email,
              uid: registereduser.uid,
              profilePhoto: registereduser.photoURL,
              lastOpenedProjectId: '',
              lastOpenedDocumentId: '');

          await firedartFirestore
              .collection('users')
              .document(registereduser.uid)
              .set(user.toJson());

          client.close();
        });
      } catch (err) {
        // something went wrong
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      isLoging = true;
      update();

      googleSignIn.disconnect();

      try {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleSignInAccount.authentication;
          final crendentials = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
              await _auth.signInWithCredential(crendentials);

          User? registereduser = userCredential.user;

          model.User user = model.User(
              name: registereduser!.displayName,
              email: registereduser.email,
              uid: registereduser.uid,
              profilePhoto: registereduser.photoURL,
              lastOpenedProjectId: '',
              lastOpenedDocumentId: '');

          await firestore
              .collection('users')
              .doc(registereduser.uid)
              .set(user.toJson());
        }
        // } on FirebaseAuthException {
        //   getErrorSnackBar(
        //     "Google Login Failed",
        //   );
        // } on PlatformException {
        //   getErrorSnackBar(
        //     "Google Login Failed",
        //   );
      } catch (e) {
        getErrorSnackBar(
          e.toString(),
        );
      }
    }
  }

  void forgorPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // getSuccessSnackBar("Reset mail sent successfully. Check mail!");
    } on FirebaseAuthException {
      getErrorSnackBar(
        "Error",
      );
    }
  }

  void signOut() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
    await Get.deleteAll();
    await Get.delete<ProfileController>(force: true);
  }
}
