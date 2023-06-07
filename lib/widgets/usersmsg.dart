import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/cached_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ava/widgets/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/style.dart';

Padding usersMsg(BuildContext context,
    {DateTime? created,
    String? comment,
    String? type,
    Map? files,
    String? username,
    String? profileUrl,
    String? nameFirstChar}) {
  var formatter = DateFormat('MM/dd/yyyy');
  final now = DateTime.now();
  String formattedTime = DateFormat('k:mm a').format(created!);
  String formattedDateDay = formatter.format(created);
  String formattedCommentDate = formattedDateDay;
  String formattedDateToday = formatter.format(now);

  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileUrl != null && profileUrl.isNotEmpty
            ? cachedImage(
                context,
                isUploading: false,
                isAppBar: false,
                isDrawer: false,
                url: profileUrl,
              )
            : CircleAvatar(
                backgroundColor: const Color(secondaryColor),
                maxRadius: 20,
                child: Center(
                  child: txt(
                      txt: username != null ? username[0].toUpperCase() : 'U',
                      fontSize: 20,
                      fontColor: Colors.white),
                ),
              ),
        SizedBox(
          width: screenWidth(context) * 0.005,
        ),
        type == 'text'
            ? Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        textSpanForUserMsg(
                          text: username,
                          fontSize: 22,
                        ),
                        textSpanForUserMsg(
                          fontWeight: FontWeight.normal,
                          text: '   $formattedTime',
                        ),
                        const Spacer(),
                        textSpanForUserMsg(
                          fontWeight: FontWeight.normal,
                          text: formattedDateDay == formattedDateToday
                              ? ''
                              : formattedCommentDate,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.003,
                    ),
                    textSpanForUserMsg(
                      text: comment,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              )
            : fileContinerSizedBox(
                context,
                username,
                comment,
                files!,
                formattedTime,
                formattedDateDay,
                formattedDateToday,
                formattedCommentDate)
      ],
    ),
  );
}

Flexible fileContinerSizedBox(
  BuildContext context,
  String? username,
  String? comment,
  Map files,
  String formattedTime,
  String formattedDateDay,
  String formattedDateToday,
  String formattedCommentDate,
) {
  return Flexible(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          textSpanForUserMsg(
            text: username,
            fontSize: 22,
          ),
          textSpanForUserMsg(
            fontWeight: FontWeight.normal,
            text: '   $formattedTime',
          ),
          const Spacer(),
          textSpanForUserMsg(
            fontWeight: FontWeight.normal,
            text: formattedDateDay == formattedDateToday
                ? ''
                : formattedCommentDate,
          ),
        ],
      ),
      SizedBox(
        height: screenHeight(context) * 0.003,
      ),
      textSpanForUserMsg(
        text: comment,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      SizedBox(
        height: screenHeight(context) * 0.01,
      ),
      fileContainerForUserMsg(context, files),
    ],
  ));
}

Widget fileContainerForUserMsg(
  BuildContext context,
  Map files,
) {
  return files.isEmpty
      ? const SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Color(mainColor),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(secondaryColor),
                ),
              ),
            ),
          ))
      : GetBuilder<ProjectController>(
          init: ProjectController(),
          builder: (controller) => GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
              ),
              shrinkWrap: true,
              itemCount: files.length,
              itemBuilder: (context, i) {
                String fileExtension = files.keys.elementAt(i).split('.').last;
                String thumbnailUrl;
                if (fileExtension == 'jpg' ||
                    fileExtension == 'jpeg' ||
                    fileExtension == 'png' ||
                    fileExtension == 'gif') {
                  thumbnailUrl = files.values.elementAt(i);
                } else if (fileExtension == 'pdf') {
                  thumbnailUrl =
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/PDF_file_icon.svg/1200px-PDF_file_icon.svg.png';
                } else if (fileExtension == 'doc' || fileExtension == 'docx') {
                  thumbnailUrl =
                      'https://w7.pngwing.com/pngs/111/216/png-transparent-doc-docx-symbol-web-save-file-document-icon-word-button-thumbnail.png';
                } else if (fileExtension == 'xls' ||
                    fileExtension == 'xlsx' ||
                    fileExtension == 'csv') {
                  thumbnailUrl =
                      'https://e7.pngegg.com/pngimages/331/486/png-clipart-microsoft-excel-logo-microsoft-excel-computer-icons-xls-microsoft-angle-text-thumbnail.png';
                } else if (fileExtension == 'mp4' ||
                    fileExtension == 'mov' ||
                    fileExtension == 'avi' ||
                    fileExtension == 'wmv') {
                  thumbnailUrl =
                      'https://w7.pngwing.com/pngs/734/1007/png-transparent-telecharger-download-button-icon-mp4-file-video-movie-web-button-internet-thumbnail.png';
                } else {
                  thumbnailUrl =
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNNuwPA8Ec9CmcwSqWB2DAzjoN7AflV6gI_w&usqp=CAU';
                }
                Widget fileNameWidget;
                if (fileExtension == 'jpg' ||
                    fileExtension == 'jpeg' ||
                    fileExtension == 'png' ||
                    fileExtension == 'gif') {
                  fileNameWidget = const SizedBox();
                } else {
                  fileNameWidget = Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: txt(
                        txt: files.keys.elementAt(i),
                        fontColor: const Color(secondaryColor),
                        fontSize: 16),
                  );
                }

                // Display file size only if file is not an image
                Widget fileSizeWidget;
                if (fileExtension == 'jpg' ||
                    fileExtension == 'jpeg' ||
                    fileExtension == 'png' ||
                    fileExtension == 'gif') {
                  fileSizeWidget = const SizedBox();
                } else {
                  fileSizeWidget = const SizedBox();
                  // fileSizeWidget = FutureBuilder<http.Response>(
                  //   future: http.get(Uri.parse(files.values.elementAt(i))),
                  //   builder: (context, snapshot) {
                  //     try {
                  //       if (snapshot.hasData) {
                  //         // If the response is available, calculate and display the file size
                  //         int fileSizeInBytes = snapshot.data!.bodyBytes.length;
                  //         String fileSize = filesize(fileSizeInBytes);

                  //         return Text(
                  //           fileSize,
                  //           style: const TextStyle(
                  //             color: Colors.grey,
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 12,
                  //           ),
                  //         );
                  //       } else {
                  //         // No data available
                  //         return const SizedBox();
                  //       }
                  //     } catch (e) {
                  //       print('Error fetching file size: $e');
                  //       // Handle the exception gracefully, e.g., display an error message
                  //       return Text(
                  //         'Error fetching file size',
                  //         style: const TextStyle(
                  //           color: Colors.red,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 12,
                  //         ),
                  //       );
                  //     }
                  //   },
                  // );
                }

                return controller.uploadProgress[files.values.elementAt(i)] !=
                            null &&
                        controller.uploadProgress[files.values.elementAt(i)] >=
                            0 &&
                        controller.uploadProgress[files.values.elementAt(i)] <
                            100
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          const Color(secondaryColor),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(mainColor)),
                                      value: double.parse(controller
                                          .uploadProgress[
                                              files.values.elementAt(i)]
                                          .toString()),
                                    ),
                                  ),
                                  Text(
                                    '${controller.uploadProgress[files.values.elementAt(i)]}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            txt(txt: files.keys.elementAt(i), fontSize: 16),
                          ])
                    : GestureDetector(
                        onTap: () {
                          downloadFile(files.values.elementAt(i),
                              files.keys.elementAt(i));
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: FastCachedImage(
                                          url: thumbnailUrl,
                                          fit: BoxFit.cover,
                                          fadeInDuration:
                                              const Duration(milliseconds: 500),
                                          errorBuilder:
                                              (context, exception, stacktrace) {
                                            return Container();
                                          },
                                          loadingBuilder: (context, progress) {
                                            return const CircleAvatar(
                                              backgroundColor: Color(mainColor),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(secondaryColor),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                fileNameWidget,
                                fileSizeWidget,
                              ],
                            )),
                      );
              }));
}

textSpanForUserMsg(
    {String? text,
    double? fontSize,
    Color? fontColor,
    FontWeight? fontWeight}) {
  return SelectableText(
    text ?? '',
    style: GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: fontSize ?? 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
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
}
