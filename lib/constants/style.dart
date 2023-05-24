import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firedart/firedart.dart' as firedart;

const int mainColor = 0xff736879;
const int secondaryColor = 0xff958890;
const Color brownishColor = Color(0xff707070);

//sharedPreferences Keys

const int darkgreyishColor = 0xff304869;
//status
const String todo = 'todo';
const String inProgress = 'inProgress';
const String completed = 'completed';
//drawer Keys
const String notesDrawerKey = 'notesDrawerKey';
final GlobalKey<ScaffoldState> scaffoldNotesDrawerKey =
    GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldAssetsDrawerKey =
    GlobalKey<ScaffoldState>();

const String assetsDrawerKey = 'assetsDrawerKey';
//assetCategories
const String newAssetCategory = 'Create new category';
const String noCategory = 'No category';
//projectCategories
const String newProjectCategory = 'Create new category';
const String designCategory = '3D design';
const String opticalCategory = 'Optical Design';
//assetType
const String linkAssetType = 'linkAssetType';
const String fileAssetType = 'fileAssetType';

var titleBarButtonColors = WindowButtonColors(
    mouseOver: const Color(secondaryColor), iconNormal: Colors.white);
var titleBarClosingButtonColors =
    WindowButtonColors(mouseOver: Colors.red, iconNormal: Colors.white);
// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
var firedartFirestore = firedart.Firestore.instance;

Widget popUpCloseButton = InkWell(
  onTap: () {
    Get.back();
  },
  child: const Icon(
    Icons.close,
  ),
);

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
                color: fontColor,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            )
          : GoogleFonts.comfortaa(
              textStyle: TextStyle(
                overflow: overflow ?? TextOverflow.visible,
                letterSpacing: letterSpacing ?? 0,
                color: fontColor,
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
      textStyle: const TextStyle(
        fontSize: 14,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

getErrorSnackBar(String message) {
  Get.snackbar(
    'Error',
    message,
    maxWidth: 600,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xffF44336),
    titleText: txt(txt: 'Error', fontSize: 24, fontColor: Colors.white),
    messageText: txt(txt: message, fontSize: 22, fontColor: Colors.white),
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

// getSuccessSnackBar(String message) {
//   Get.snackbar(
//     message,
//     'Success',
//     maxWidth: 600,
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: const Color(0xff4CAF50),
//     titleText: txt(txt: 'Success', fontSize: 24, fontColor: Colors.white),
//     messageText: txt(txt: message, fontSize: 22, fontColor: Colors.white),
//     borderRadius: 10,
//     margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
//   );
// }

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
