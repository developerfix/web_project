import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart' as photoview;
import 'package:projectx/constants/style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PhotoView extends StatefulWidget {
  final String url;
  const PhotoView({Key? key, required this.url}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          //  SizedBox(
          // // height: screenHeight(context) * 0.6,
          // // width: screenWidth(context) * 0.6,
          // child:
          Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
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
                child: SfPdfViewer.network(widget.url,
                    enableDoubleTapZooming: false)
                // photoview.PhotoView(
                //   imageProvider: NetworkImage(widget.url),
                // ),
                ),
          ],
        ),
      ),
      // ),
    );
  }
}
