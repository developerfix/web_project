// import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const int mainColor = 0xff736879;
const int secondaryColor = 0xff958890;
const int brownishColor = 0xff707070;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//for all the text in the app
Widget txt(
    {required String txt,
    FontWeight? fontWeight,
    required double fontSize,
    Color? fontColor,
    double? minFontSize,
    double? letterSpacing,
    TextOverflow? overflow,
    int? maxLines}) {
  return AutoSizeText(
    txt,
    maxLines: maxLines ?? 2,
    maxFontSize: fontSize,
    minFontSize: minFontSize ?? fontSize - 5,
    style: GoogleFonts.montserrat(
      textStyle: TextStyle(
        overflow: overflow ?? TextOverflow.visible,
        letterSpacing: letterSpacing ?? 0,
        color: fontColor ?? const Color(brownishColor),
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    ),
  );
}

getErrorSnackBar(String message, _) {
  Get.snackbar(
    "Error",
    "$message\n${_.message}",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade300,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

getErrorSnackBarNew(String message) {
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade300,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

getSuccessSnackBar(String message) {
  Get.snackbar(
    "Success",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.shade300,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
