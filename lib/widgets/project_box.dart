import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

import '../constants/style.dart';

HoverContainer projectBox(BuildContext context, {String? text}) {
  return HoverContainer(
    hoverWidth: 250,
    decoration: BoxDecoration(
      color: const Color(secondaryColor).withOpacity(0.5),
      borderRadius: BorderRadius.circular(12.0),
    ),
    hoverDecoration: BoxDecoration(
        color: const Color(secondaryColor),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: null),
    child: Center(
        child: txt(
            txt: text!,
            textAlign: TextAlign.center,
            fontSize: 30.0,
            maxLines: 3,
            minFontSize: 24,
            letterSpacing: 2,
            overflow: TextOverflow.ellipsis,
            fontColor: Colors.white)),
  );
}

HoverContainer hoveredProjectBox(BuildContext context, {String? text}) {
  return HoverContainer(
    hoverWidth: 250,
    decoration: BoxDecoration(
      color: const Color(secondaryColor).withOpacity(0.5),
      borderRadius: BorderRadius.circular(12.0),
    ),
    hoverDecoration: BoxDecoration(
        color: const Color(secondaryColor),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: null),
    child: Center(
        child: txt(
            txt: text!,
            textAlign: TextAlign.center,
            fontSize: 30.0,
            maxLines: 3,
            minFontSize: 24,
            letterSpacing: 2,
            overflow: TextOverflow.ellipsis,
            fontColor: Colors.red)),
  );
}

Row departmentBox(
  BuildContext context, {
  String? text,
  int? iconCode,
}) {
  return Row(
    children: [
      SizedBox(
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white, width: 2)),
          child: Icon(
              IconData(
                iconCode!,
                fontFamily: 'MaterialIcons',
              ),
              color: Colors.white),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: txt(
            txt: text!.toUpperCase(),
            fontSize: 30.0,
            maxLines: 1,
            minFontSize: 24,
            letterSpacing: 2,
            overflow: TextOverflow.ellipsis,
            fontColor: Colors.white),
      )
    ],
  );
}

Row hoveredDepartmentBox(BuildContext context, {String? text}) {
  return Row(
    children: [
      SizedBox(
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
              color: const Color(secondaryColor),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: null),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: txt(
            txt: text!.toUpperCase(),
            fontSize: 30.0,
            maxLines: 1,
            minFontSize: 24,
            letterSpacing: 2,
            overflow: TextOverflow.ellipsis,
            fontColor: Colors.white),
      )
    ],
  );
}
