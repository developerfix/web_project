import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
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
        // txt(
        //   txt: '@${username!}:',
        //   fontSize: 12,
        //   maxLines: 1,
        // ),
        type == 'text'
            ? Flexible(
                child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: username!,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              overflow: TextOverflow.visible,
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        )),
                    TextSpan(
                        text:
                            ' $formattedTime${formattedDateDay == formattedDateToday ? '' : formattedCommentDate}\n',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              overflow: TextOverflow.visible,
                              color: Color(brownishColor),
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        )),
                    TextSpan(
                        text: comment!,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              overflow: TextOverflow.visible,
                              color: Color(brownishColor),
                              fontWeight: FontWeight.normal,
                              fontSize: 18),
                        )),
                  ],
                ),
              ))
            : InkWell(
                onTap: () {
                  downloadFile(comment, filename);
                },
                child: screenWidth(context) < 1800
                    ? SizedBox(
                        width: screenWidth(context) * 0.15,
                        height: screenHeight(context) * 0.075,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: username!,
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              overflow: TextOverflow.visible,
                                              color: Color(brownishColor),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                    TextSpan(
                                        text:
                                            ' $formattedTime${formattedDateDay == formattedDateToday ? '' : formattedCommentDate}\n',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              overflow: TextOverflow.visible,
                                              color: Color(brownishColor),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: screenWidth(context) * 0.1,
                              height: screenHeight(context) * 0.045,
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
                              child: Column(
                                children: [
                                  Flexible(
                                      child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '@$username:\n',
                                            style: GoogleFonts.montserrat(
                                              textStyle: const TextStyle(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  color: Color(brownishColor),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            )),
                                      ],
                                    ),
                                  )),
                                  Center(
                                    child: txt(
                                        txt: 'Download file',
                                        fontSize: 14,
                                        fontColor: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: screenWidth(context) * 0.15,
                        height: screenHeight(context) * 0.075,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: username!,
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              overflow: TextOverflow.visible,
                                              color: Color(brownishColor),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                    TextSpan(
                                        text:
                                            ' $formattedTime${formattedDateDay == formattedDateToday ? '' : formattedCommentDate}\n',
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              overflow: TextOverflow.visible,
                                              color: Color(brownishColor),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: screenWidth(context) * 0.1,
                              height: screenHeight(context) * 0.045,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.005,
                                    ),
                                    txt(
                                        txt: 'click to download',
                                        fontSize: 14,
                                        fontColor: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
      ],
    ),
  );
}

downloadFile(url, filename) async {
  if (!kIsWeb) {
    String? res = await FilePicker.platform.saveFile(
      fileName: filename.split('.').first,
    );

    if (res != null) {
      var dio = Dio();

      var ext = filename.split('.').last;

      String fullPath = "$res.$ext";
      await dio.download(url, fullPath);
    }
  } else {
    html.window.open(
      url,
      filename,
    );
  }
}
