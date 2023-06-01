import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

Container assetCategoryDropDownButton(
    BuildContext context, StateSetter setState,
    {String? phase}) {
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: authController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Center(
      child: DropdownButtonFormField(
        // itemHeight: 15,
        // menuMaxHeight: 30,
        items:
            <String>['No category', 'Create new category'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),

        onChanged: (value) {
          setState(() {
            projectController.assetCategory.value = value.toString();
            projectController.update();
          });
        },
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0,
            color: brownishColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintStyle: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
              letterSpacing: 0,
              color: brownishColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          hintText: phase ?? projectController.assetCategory.value,
          fillColor:
              authController.isDarkTheme.value ? Colors.black12 : Colors.white,
        ),
      ),
    ),
  );
}
