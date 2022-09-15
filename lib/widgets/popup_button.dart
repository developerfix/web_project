import 'package:flutter/material.dart';

import '../constants/style.dart';

InkWell popupButton(BuildContext context,
    {required String text, required Function() ontap}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      width: screenWidth(context) < 800
          ? screenWidth(context) * 0.3
          : screenWidth(context) * 0.1,
      height: screenHeight(context) * 0.05,
      decoration: brownishBoxDecoration,
      child:
          Center(child: txt(txt: text, fontSize: 15, fontColor: Colors.white)),
    ),
  );
}
