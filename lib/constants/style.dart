import 'package:ava/controllers/profile_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:ava/controllers/project_controller.dart';

const int mainColor = 0xff736879;
const int secondaryColor = 0xff958890;
const int brownishColor = 0xff707070;
const int darkgreyishColor = 0xff304869;

var titleBarButtonColors = WindowButtonColors(
    mouseOver: const Color(secondaryColor), iconNormal: Colors.white);
var titleBarClosingButtonColors =
    WindowButtonColors(mouseOver: Colors.red, iconNormal: Colors.white);
// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
var firedartFirestore = firedart.Firestore.instance;

final ProjectController projecttController = Get.find();
final ProfileController profileController = Get.find();

// final TextStyle montserratTextStyle = GoogleFonts.montserrat(
//         textStyle: TextStyle(
//             overflow: TextOverflow.visible,
//             color: projecttController.isDarkTheme.value
//                 ? Colors.white60
//                 : const Color(brownishColor),
//             fontWeight: fontWeight ?? FontWeight.w600,
//             fontSize: fontSize ?? 14),
//       )

BoxDecoration darkThemeBoxDecoration = BoxDecoration(
  color: Colors.black45,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      offset: const Offset(0, 3.0),
      blurRadius: 6.0,
    ),
  ],
  borderRadius: BorderRadius.circular(10.0),
);
BoxDecoration lightThemeBoxDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      offset: const Offset(0, 3.0),
      blurRadius: 6.0,
    ),
  ],
  borderRadius: BorderRadius.circular(10.0),
);

BoxDecoration brownishBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  color: const Color(0xFF958890),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.23),
      offset: const Offset(0, 3.0),
      blurRadius: 9.0,
    ),
  ],
);

//for all the text in the app
Widget txt(
    {required String txt,
    FontWeight? fontWeight,
    required double fontSize,
    Color? fontColor,
    double? minFontSize,
    double? letterSpacing,
    TextOverflow? overflow,
    TextAlign? textAlign,
    String? font,
    int? maxLines}) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    return AutoSizeText(
      txt,
      maxLines: maxLines ?? (constraints.maxWidth < 600 ? 2 : 10),
      maxFontSize: fontSize,
      minFontSize: minFontSize ?? fontSize - 5,
      textAlign: textAlign,
      style: font == null
          ? GoogleFonts.montserrat(
              textStyle: TextStyle(
                overflow: overflow ?? TextOverflow.ellipsis,
                letterSpacing: letterSpacing ?? 0,
                color: fontColor ??
                    (projecttController.isDarkTheme.value
                        ? Colors.white60
                        : const Color(brownishColor)),
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            )
          : GoogleFonts.comfortaa(
              textStyle: TextStyle(
                overflow: overflow ?? TextOverflow.visible,
                letterSpacing: letterSpacing ?? 0,
                color: fontColor ??
                    (projecttController.isDarkTheme.value
                        ? Colors.white60
                        : const Color(brownishColor)),
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
    );
  });
}

Text popText(String status) {
  return Text(
    status,
    maxLines: 1,
    style: GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: 14,
        overflow: TextOverflow.visible,
        color: projecttController.isDarkTheme.value
            ? Colors.white54
            : const Color(brownishColor),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

getErrorSnackBar(String message) {
  Get.snackbar(
    message,
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade100,
    colorText: Colors.black38,
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
