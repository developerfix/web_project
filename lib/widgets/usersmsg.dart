import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Ava/widgets/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/style.dart';

Padding usersMsg(BuildContext context,
    {DateTime? created,
    String? comment,
    String? type,
    String? username,
    String? filename,
    String? nameFirstChar}) {
  var formatter = DateFormat('MM/dd/yyyy');
  final now = DateTime.now();
  String formattedTime = DateFormat('k:mm:a').format(created!);
  String formattedDateDay = formatter.format(created);
  String formattedCommentDate = ', $formattedDateDay';
  String formattedDateToday = formatter.format(now);

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: const Color(brownishColor),
          maxRadius: 25,
          child: Center(
            child: txt(
                txt: nameFirstChar!.capitalize.toString(),
                fontSize: 20,
                fontColor: Colors.white),
          ),
        ),
        SizedBox(
          width: screenWidth(context) * 0.005,
        ),
        type == 'text'
            ? Flexible(
                child: Text.rich(
                TextSpan(
                  children: [
                    textSpanForUserMsg(text: username),
                    textSpanForUserMsg(
                      fontWeight: FontWeight.normal,
                      text:
                          ' $formattedTime${formattedDateDay == formattedDateToday ? '' : formattedCommentDate}\n',
                    ),
                    textSpanForUserMsg(
                        text: comment,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ],
                ),
              ))
            : InkWell(
                onTap: () {
                  downloadFile(comment, filename);
                },
                child: fileContinerSizedBox(
                    context,
                    username,
                    formattedTime,
                    formattedDateDay,
                    formattedDateToday,
                    formattedCommentDate,
                    filename)),
      ],
    ),
  );
}

SizedBox fileContinerSizedBox(
    BuildContext context,
    String? username,
    String formattedTime,
    String formattedDateDay,
    String formattedDateToday,
    String formattedCommentDate,
    String? filename) {
  return SizedBox(
    width: screenWidth(context) * 0.15,
    height: screenHeight(context) * 0.08,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: Text.rich(
          TextSpan(
            children: [
              textSpanForUserMsg(text: username),
              textSpanForUserMsg(
                fontWeight: FontWeight.normal,
                text:
                    ' $formattedTime${formattedDateDay == formattedDateToday ? '' : formattedCommentDate}\n',
              ),
            ],
          ),
        )),
        const Spacer(),
        fileContainerForUserMsg(context, filename),
      ],
    ),
  );
}

Container fileContainerForUserMsg(BuildContext context, String? filename) {
  return Container(
    width: screenWidth(context) * 0.1,
    height: screenHeight(context) * 0.05,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: const Color(secondaryColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: const Offset(0, 3.0),
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Center(
      child: txt(txt: filename!, fontSize: 14, fontColor: Colors.white),
    ),
  );
}

TextSpan textSpanForUserMsg(
    {String? text, double? fontSize, FontWeight? fontWeight}) {
  return TextSpan(
      text: text!,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            overflow: TextOverflow.visible,
            color: projecttController.isDarkTheme.value
                ? Colors.white60
                : const Color(brownishColor),
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: fontSize ?? 14),
      ));
}

downloadFile(url, filename) async {
  if (!kIsWeb) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg") {
      return Get.to(() => PhotoView(
            url: url,
            filename: filename,
          ));
    } else if (typeString == "jpeg") {
      return Get.to(() => PhotoView(
            url: url,
            filename: filename,
          ));
    } else if (typeString == "png") {
      return Get.to(() => PhotoView(
            url: url,
            filename: filename,
          ));
    } else {
      return await canLaunchUrl(Uri.parse(url))
          ? await launchUrl(Uri.parse(url))
          : null;
    }
  } else {
    return await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : null;
  }

// if (!kIsWeb) {
  //   String? res = await FilePicker.platform.saveFile(
  //     fileName: filename.split('.').first,
  //   );

  //   if (res != null) {
  //     var dio = Dio();

  //     var ext = filename.split('.').last;

  //     String fullPath = "$res.$ext";
  //     await dio.download(url, fullPath);
  //   }
  // } else {
  // await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url)) : null;
  // html.window.open(
  //   url,
  //   filename,
  // );
  // }
}
