import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

Padding cachedImage(
  BuildContext context, {
  required bool isUploading,
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
        child: isUploading
            ? CircleAvatar(
                backgroundColor: isDrawer != null
                    ? const Color(secondaryColor)
                    : const Color(mainColor),
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDrawer != null
                        ? const Color(mainColor)
                        : const Color(secondaryColor),
                  ),
                ),
              )
            : FastCachedImage(
                url: url,
                fit: BoxFit.fill,
                width: isDrawer != null ? 90 : 40,
                height: isDrawer != null ? 90 : 40,
                fadeInDuration: const Duration(milliseconds: 500),
                errorBuilder: (context, exception, stacktrace) {
                  return Container();
                },
                loadingBuilder: (context, progress) {
                  return CircleAvatar(
                    backgroundColor: isDrawer != null
                        ? const Color(secondaryColor)
                        : const Color(mainColor),
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
