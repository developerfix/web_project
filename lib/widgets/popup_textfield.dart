import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';

Container popUpTextField(
  BuildContext context, {
  TextEditingController? controller,
  String? hint,
}) {
  return Container(
    width: screenWidth(context) < 1200
        ? screenWidth(context) * 0.5
        : screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: const Offset(0, 3.0),
          blurRadius: 6.0,
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
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
