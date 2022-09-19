import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';

Container popUpTextField(BuildContext context,
    {TextEditingController? controller,
    double? height,
    String? hint,
    int? maxLines}) {
  return Container(
    width: screenWidth(context) < 1200
        ? screenWidth(context) * 0.5
        : screenWidth(context) * 0.2,
    height: height ?? screenHeight(context) * 0.05,
    decoration: projecttController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        validator: (val) {
          if (val!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Color(secondaryColor),
            fontWeight: FontWeight.w600,
          ),
        ),
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              letterSpacing: 2,
              color: Color(secondaryColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
