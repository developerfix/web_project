import 'package:flutter/material.dart';

BoxDecoration lightThemeDecoration() {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.16),
        offset: const Offset(0, 3.0),
        blurRadius: 6.0,
      ),
    ],
    borderRadius: BorderRadius.circular(10.0),
  );
}

BoxDecoration darkThemeDecoration() {
  return BoxDecoration(
    color: Colors.black26,
    boxShadow: [
      BoxShadow(
        color: Colors.black26.withOpacity(0.16),
        offset: const Offset(0, 3.0),
        blurRadius: 6.0,
      ),
    ],
    borderRadius: BorderRadius.circular(10.0),
  );
}
