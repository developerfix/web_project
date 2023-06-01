import 'dart:convert';

import 'package:context_menus/context_menus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart' as photoview;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  final String url;
  final String filename;
  const PhotoView({
    Key? key,
    required this.url,
    required this.filename,
  }) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          Get.back();
          // Perform your desired action for the ESC key press here
        }
      },
      child: ContextMenuOverlay(
        /// Make a custom background
        cardBuilder: (_, children) =>
            Container(color: Colors.black, child: Column(children: children)),

        /// Make custom buttons
        buttonBuilder: (_, config, [__]) => TextButton(
          onPressed: config.onPressed,
          child: SizedBox(
              width: double.infinity,
              child: Text(
                config.label,
                style: const TextStyle(color: Colors.white),
              )),
        ),
        child: TestContent(
          url: widget.url,
          filename: widget.filename,
        ),
      ),
    ));
  }
}

class TestContent extends StatelessWidget {
  const TestContent({Key? key, required this.url, required this.filename})
      : super(key: key);
  final String filename;

  final String url;
  Future<Uint8List> getImageBytes(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return base64Decode(base64.encode(bytes));
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:

                /// Custom Context Menu for an Image
                //   ContextMenuRegion(
                // contextMenu: GenericContextMenu(
                //   buttonConfigs: [
                //     ContextMenuButtonConfig("Download", onPressed: () async {
                //       String? res = await FilePicker.platform.saveFile(
                //         fileName: filename.split('.').first,
                //       );

                //       if (res != null) {
                //         var dio = Dio();

                //         var ext = filename.split('.').last;

                //         String fullPath = "$res.$ext";
                //         await dio.download(url, fullPath);
                //       }
                //     }),
                //     ContextMenuButtonConfig("Copy to clipboard",
                //         onPressed: () async {
                //       try {
                //         // Pasteboard.writeImage(await getImageBytes(url));
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content:
                //                 Center(child: const Text("Copied to Clipboard")),
                //             behavior: SnackBarBehavior.floating,
                //             width: 280, // adjust the width as needed
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //           ),
                //         );
                //       } catch (e) {
                //         print('erorr: $e');
                //       }
                //     })
                //   ],
                // ),
                // child:
                photoview.PhotoView(
              imageProvider: NetworkImage(url),
              enableRotation: true,
              filterQuality: FilterQuality.high,
              gestureDetectorBehavior: HitTestBehavior.deferToChild,
            ),
            // ),
          ),
          Column(
            children: [
              InkWell(
                onTap: (() => Get.back()),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: (() async {
                  String? res = await FilePicker.platform.saveFile(
                    fileName: filename.split('.').first,
                  );

                  if (res != null) {
                    var dio = Dio();

                    var ext = filename.split('.').last;

                    String fullPath = "$res.$ext";
                    await dio.download(url, fullPath);
                  }
                }),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.download_for_offline_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
