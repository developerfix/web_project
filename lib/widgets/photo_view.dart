import 'package:context_menus/context_menus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart' as photoview;

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
  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
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
    );
  }
}

class TestContent extends StatelessWidget {
  const TestContent({Key? key, required this.url, required this.filename})
      : super(key: key);
  final String filename;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (() => Get.back()),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child:

                /// Custom Context Menu for an Image
                ContextMenuRegion(
              contextMenu: GenericContextMenu(
                buttonConfigs: [
                  ContextMenuButtonConfig("Download", onPressed: () async {
                    // http.Response response = await http.get(Uri.parse(url));
                    // final bytes = response.bodyBytes;
                    // String base64Image = base64UrlEncode(bytes);
                    // final data = base64Decode(base64Image);
                    // Pasteboard.writeImage(data);

                    // // final kImageBase64 = await networkImageToBase64(url);
                    // // final data = base64Decode(kImageBase64!);
                    // // Pasteboard.writeImage(bytes);

                    String? res = await FilePicker.platform.saveFile(
                      fileName: filename.split('.').first,
                    );

                    if (res != null) {
                      var dio = Dio();

                      var ext = filename.split('.').last;

                      String fullPath = "$res.$ext";
                      await dio.download(url, fullPath);
                    }
                  })
                ],
              ),
              child: photoview.PhotoView(
                imageProvider: NetworkImage(url),
                enableRotation: true,
                filterQuality: FilterQuality.high,
                heroAttributes:
                    const photoview.PhotoViewHeroAttributes(tag: 'photo'),
                gestureDetectorBehavior: HitTestBehavior.deferToChild,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
