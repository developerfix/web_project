import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

Padding cachedImage(
  BuildContext context, {
  double? height,
  double? width,
  double? fontSize,
  double? maxRadius,
  bool? isDrawer,
  bool? isAppBar,
  required String url,
}) {
  return Padding(
    padding: isAppBar != null
        ? const EdgeInsets.all(8.0)
        : const EdgeInsets.all(0.0),
    child: ClipOval(
        child: FastCachedImage(
      url: url,
      fit: BoxFit.fill,
      width: isDrawer != null ? 90 : 40,
      height: isDrawer != null ? 90 : null,
      fadeInDuration: const Duration(seconds: 1),
      errorBuilder: (context, exception, stacktrace) {
        return Text(stacktrace.toString());
      },
      loadingBuilder: (context, progress) {
        return CircleAvatar(
          backgroundColor: isDrawer != null
              ? const Color(mainColor)
              : const Color(secondaryColor),
          child: Center(
            child: CircularProgressIndicator(
              color: isDrawer != null
                  ? const Color(mainColor)
                  : const Color(secondaryColor),
            ),
          ),
        );
      },
    )),
  );
}
