import 'package:ava/widgets/popup_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

Column newCategoryTextField(
    BuildContext context, TextEditingController categoryTitleController) {
  return Column(
    children: [
      SizedBox(
        height: screenHeight(context) * 0.04,
      ),
      Row(
        children: [
          SizedBox(
            width: screenWidth(context) * 0.15,
            child: txt(
              minFontSize: 18,
              txt: 'New category title:',
              fontSize: 30,
            ),
          ),
          SizedBox(
            width: screenWidth(context) * 0.02,
          ),
          popUpTextField(context,
              controller: categoryTitleController, hint: 'exp: Media files'),
        ],
      ),
    ],
  );
}

Row categoryDropDown(BuildContext context, AuthController authController,
    StateSetter setState, ProjectController projectController) {
  return Row(
    children: [
      SizedBox(
        width: screenWidth(context) * 0.15,
        child: txt(
          minFontSize: 18,
          maxLines: 1,
          txt: 'Category:',
          fontSize: 30,
        ),
      ),
      SizedBox(
        width: screenWidth(context) * 0.02,
      ),
      Container(
        width: 450,
        height: 60,
        decoration: authController.isDarkTheme.value
            ? darkThemeBoxDecoration
            : lightThemeBoxDecoration,
        child: Center(
          child: DropdownButtonFormField(
            // itemHeight: 15,
            // menuMaxHeight: 30,
            items: projectController.assetsCategories.map((String value) {
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
              hintText: projectController.assetCategory.value,
              fillColor: authController.isDarkTheme.value
                  ? Colors.black12
                  : Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
