// import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const int mainColor = 0xff736879;
const int secondaryColor = 0xff958890;
const int brownishColor = 0xff707070;

//for all the text in the app
Widget txt(
    {required String txt,
    FontWeight? fontWeight,
    required double fontSize,
    Color? fontColor,
    double? minFontSize,
    double? letterSpacing,
    int? maxLines}) {
  return AutoSizeText(
    txt,
    maxLines: maxLines ?? 2,
    maxFontSize: fontSize,
    minFontSize: minFontSize ?? fontSize - 5,
    style: GoogleFonts.montserrat(
      textStyle: TextStyle(
        letterSpacing: letterSpacing ?? 0,
        color: fontColor ?? Colors.white,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    ),
  );
}

Widget navigator({Widget? child, Widget? page}) {
  return PageLink(links: [
    PageLinkInfo(
        transition: LinkTransition.Fade,
        ease: Curves.easeOut,
        duration: 0.3,
        pageBuilder: () => page),
  ], child: child!);
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
