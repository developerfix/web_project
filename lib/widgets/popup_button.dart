import 'package:flutter/material.dart';

import '../constants/style.dart';

InkWell popupButton(BuildContext context,
    {required String text, required Function() ontap}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(mainColor),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(secondaryColor),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: txt(
          minFontSize: 24,
          maxLines: 1,
          letterSpacing: 3,
          fontColor: Colors.white,
          font: 'comfortaa',
          txt: text,
          fontSize: 30,
        ),
      ),
    ),
  );
}
