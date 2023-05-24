import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';

Container popUpTextField(BuildContext context,
    {TextEditingController? controller,
    double? height,
    String? hint,
    int? isObscure,
    Widget? trailing,
    int? maxLines}) {
  final AuthController authController = Get.find<AuthController>();
  bool isObscurePlus = isObscure == 1 ? true : false;
  return Container(
    width: 450,
    height: height ?? 70,
    decoration: authController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: TextFormField(
        obscureText: isObscure != null ? isObscurePlus : false,
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
          suffixIcon: trailing,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            textStyle: TextStyle(
              letterSpacing: 2,
              color: Color(secondaryColor).withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
