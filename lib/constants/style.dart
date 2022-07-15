import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firedart/firedart.dart' as firedart;

const int mainColor = 0xff736879;
const int secondaryColor = 0xff958890;
const int brownishColor = 0xff707070;
const int darkgreyishColor = 0xff304869;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
var firedartFirestore = firedart.Firestore.instance;

//for all the text in the app
Widget txt(
    {required String txt,
    FontWeight? fontWeight,
    required double fontSize,
    Color? fontColor,
    double? minFontSize,
    double? letterSpacing,
    TextOverflow? overflow,
    String? font,
    int? maxLines}) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    return AutoSizeText(
      txt,
      maxLines: maxLines ?? (constraints.maxWidth < 600 ? 2 : 10),
      maxFontSize: fontSize,
      minFontSize: minFontSize ?? fontSize - 5,
      style: font == null
          ? GoogleFonts.montserrat(
              textStyle: TextStyle(
                overflow: overflow ?? TextOverflow.visible,
                letterSpacing: letterSpacing ?? 0,
                color: fontColor ?? const Color(brownishColor),
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            )
          : GoogleFonts.comfortaa(
              textStyle: TextStyle(
                overflow: overflow ?? TextOverflow.visible,
                letterSpacing: letterSpacing ?? 0,
                color: fontColor ?? const Color(brownishColor),
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
    );
  });
}

getErrorSnackBar(String message) {
  Get.snackbar(
    message,
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade100,
    colorText: Colors.black87,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

getSuccessSnackBar(String message) {
  Get.snackbar(
    message,
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xffCBCBCB),
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
