import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';
import 'notes_section.dart';

class FilePreviewInCommentBoxWidget extends StatefulWidget {
  final List<File> commentFiles;

  const FilePreviewInCommentBoxWidget(this.commentFiles, {super.key});

  @override
  State<FilePreviewInCommentBoxWidget> createState() =>
      _FilePreviewInCommentBoxWidgetState();
}

class _FilePreviewInCommentBoxWidgetState
    extends State<FilePreviewInCommentBoxWidget> {
  List<bool> isHovered = [];

  @override
  void initState() {
    super.initState();
    isHovered = List.generate(widget.commentFiles.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.commentFiles.length,
          itemBuilder: (BuildContext context, int index) {
            final file = widget.commentFiles[index];
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered[index] = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered[index] = false;
                });
              },
              child: SizedBox(
                height: screenHeight(context) * 0.1,
                width: screenWidth(context) * 0.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: getFileType(file.path) == 'image'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(file),
                              )
                            : Container(
                                color: const Color(mainColor),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txt(
                                      txt: getFileName(file.path),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (isHovered[index])
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.commentFiles.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
