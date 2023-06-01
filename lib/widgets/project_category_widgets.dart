import 'package:ava/widgets/popup_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'add_new_task_popup.dart';

Column newProjectCategoryTextField(
    BuildContext context, TextEditingController categoryTitleController) {
  return Column(
    children: [
      Row(
        children: [
          txt(
            txt: 'New category title:',
            fontSize: 30,
          ),
          const Spacer(),
          popUpTextField(context,
              controller: categoryTitleController, hint: 'exp: Optical Design'),
        ],
      ),
    ],
  );
}

Column newTaskCategoryTextField(
    BuildContext context, TextEditingController categoryTitleController) {
  return Column(
    children: [
      Row(
        children: [
          textWidgetTaskPopup(
            context,
            'New phase:',
          ),
          const SizedBox(
            width: 10,
          ),
          popUpTextField(context,
              width: 300,
              controller: categoryTitleController,
              hint: 'exp: Optical Design'),
        ],
      ),
    ],
  );
}

Row projectCategoryDropDown(BuildContext context, AuthController authController,
    StateSetter setState, ProfileController profileController) {
  return Row(
    children: [
      txt(
        txt: 'Category:',
        fontSize: 30,
      ),
      const Spacer(),
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
            items: profileController.projectCategories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                profileController.projectCategory.value = value.toString();
                profileController.update();
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
              hintText: profileController.projectCategory.value,
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
