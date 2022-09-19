import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';

Container dropDownButton(BuildContext context, StateSetter setState,
    {String? phase}) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: projecttController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Center(
      child: DropdownButtonFormField(
        // itemHeight: 15,
        // menuMaxHeight: 30,
        items: <String>['3D Design', 'Optical Design'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),

        onChanged: (value) {
          setState(() {
            projecttController.phaseValue.value = value.toString();
            projecttController.update();
          });
        },
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0,
            color: Color(brownishColor),
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
              color: Color(brownishColor),
              fontWeight: FontWeight.w600,
            ),
          ),
          hintText: phase ?? projecttController.phaseValue.value,
          fillColor: projecttController.isDarkTheme.value
              ? Colors.black12
              : Colors.white,
        ),
      ),
    ),
  );
}
