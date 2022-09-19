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
