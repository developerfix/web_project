import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/usersmsg.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'loading_indicator.dart';

bool isBeingDragged = false;
Expanded notesSection(BoxConstraints constraints, BuildContext context,
    {ScrollController? scrollController,
    required ProjectController projectController,
    ProfileController? profileController,
    TextEditingController? commentController}) {
  final notesSearchController = TextEditingController();

  submitComment() async {
    String trimmedValue = commentController!.text.trim();
    if (trimmedValue.length >= 5) {
      if (projectController.commentFiles.isNotEmpty) {
        await projectController.addNewCommentFile(
            username: profileController!.currentUser.value.name,
            created: !kIsWeb ? DateTime.now() : Timestamp.now(),
            comment: commentController.text,
            result: projectController.commentFiles);
      } else {
        if (commentController.text.isNotEmpty) {
          await projectController.addNewComment(
              comment: commentController.text,
              username: profileController!.currentUser.value.name,
              created: !kIsWeb ? DateTime.now() : Timestamp.now());
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController!.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    }
  }

  attachFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, allowMultiple: true);

    for (var result in result!.files) {
      projectController.commentFiles.add(File(result.path!));
    }
  }

  return Expanded(
    flex: 2,
    child: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.currentUser.value.name!.isEmpty) {
            return const LoadingIndicator();
          } else {
            return StatefulBuilder(builder: (context, setState) {
              return DropTarget(
                  onDragDone: (detail) {
                    setState(() {
                      projectController.commentFiles.addAll(
                          detail.files.map((xFile) => File(xFile.path)));
                    });
                  },
                  onDragEntered: (detail) {
                    setState(() {
                      isBeingDragged = true;
                    });
                  },
                  onDragExited: (detail) {
                    setState(() {
                      isBeingDragged = false;
                    });
                  },
                  child: Padding(
                      padding: constraints.maxWidth < 800
                          ? const EdgeInsets.all(16.0)
                          : const EdgeInsets.fromLTRB(50, 30, 30, 80),
                      child: isBeingDragged
                          ? isBeingDraggedWidget(
                              context,
                              projectController,
                              notesSearchController,
                              constraints,
                              scrollController,
                              commentController,
                              submitComment,
                              setState,
                              attachFile)
                          : notBeingDraggedWidget(
                              context,
                              projectController,
                              notesSearchController,
                              constraints,
                              scrollController,
                              commentController,
                              submitComment,
                              setState,
                              attachFile)));
            });
          }
        }),
  );
}

Obx notBeingDraggedWidget(
    BuildContext context,
    ProjectController projectController,
    TextEditingController notesSearchController,
    BoxConstraints constraints,
    ScrollController? scrollController,
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    StateSetter setState,
    Future<void> Function() attachFile) {
  return Obx(
    () => Stack(
      children: [
        Column(children: [
          searchTextFieldAndFilterWidget(context,
              projectController: projectController,
              notesSearchController: notesSearchController),
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          notesTextWidget(constraints),
          projectController.isSearching.isTrue
              ? commentsSectionWidget(
                  context, projectController, scrollController)
              : isNotSearchingColumn(
                  constraints, projectController, scrollController, context),
        ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: commentBox(context, commentController, submitComment, setState,
              attachFile, projectController),
        )
      ],
    ),
  );
}

Widget notesTextWidget(BoxConstraints constraints) {
  return txt(
    txt: 'NOTES',
    fontSize: 30,
    font: 'comfortaa',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    minFontSize: constraints.maxWidth < 800 ? 24 : 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 5,
  );
}

Stack isBeingDraggedWidget(
    BuildContext context,
    ProjectController? projectController,
    TextEditingController notesSearchController,
    BoxConstraints constraints,
    ScrollController? scrollController,
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    StateSetter setState,
    Future<void> Function() attachFile) {
  final AuthController authController = Get.find();
  return Stack(
    children: [
      Column(children: [
        searchTextFieldAndFilterWidget(context,
            projectController: projectController,
            notesSearchController: notesSearchController),
        SizedBox(
          height: screenHeight(context) * 0.02,
        ),
        notesTextWidget(constraints),
        isNotSearchingColumn(
            constraints, projectController, scrollController, context),
        const Spacer(),
        commentBox(context, commentController, submitComment, setState,
            attachFile, projectController!)
      ]),
      Positioned.fill(
          child: Container(
        color: authController.isDarkTheme.value
            ? Colors.black38.withOpacity(0.4)
            : Colors.white54.withOpacity(0.8),
      ))
    ],
  );
}

Row searchTextFieldAndFilterWidget(BuildContext context,
    {ProjectController? projectController,
    ScrollController? scrollController,
    required TextEditingController notesSearchController}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      searchNotesWidget(context, projectController!, notesSearchController),
      filterButton(projectController, scrollController),
    ],
  );
}

PopupMenuButton<int> filterButton(
    ProjectController projectController, ScrollController? scrollController) {
  return PopupMenuButton(
      tooltip: 'Filter notes',
      onSelected: (value) async {
        if (value == 1) {
          projectController.commentsFilter.value = 1;
          projectController.update();
          scrollController?.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        } else if (value == 2) {
          projectController.commentsFilter.value = 2;
          projectController.update();
        } else {
          projectController.commentsFilter.value = 3;
          projectController.update();
          scrollController?.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      },
      elevation: 3.2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      itemBuilder: (context) => [
            PopupMenuItem(value: 1, child: popText('All notes')),
            PopupMenuItem(value: 2, child: popText('Text only')),
            PopupMenuItem(value: 3, child: popText('Media only')),
          ],
      child: SizedBox(
        height: Get.height * 0.017,
        child: Icon(
          Icons.filter_alt_outlined,
          size: 26,
          color: checkThemeColorwhite54,
        ),
      ));
}

Row searchNotesWidget(BuildContext context, ProjectController projectController,
    TextEditingController notesSearchController) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      SizedBox(
          width: screenWidth(context) * 0.17,
          child: TextField(
            cursorColor: checkThemeColorwhite54,
            onChanged: ((value) {
              if (value.isNotEmpty) {
                projectController.isSearching.value = true;
                projectController.searchedNote.value = value;
              } else {
                projectController.isSearching.value = false;
              }
            }),
            maxLines: 1,
            controller: notesSearchController,
            decoration: InputDecoration(
              hintStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  letterSpacing: 0,
                  color: checkThemeColorwhite54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: checkThemeColorwhite54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: checkThemeColorwhite54),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: checkThemeColorwhite54),
              ),
            ),
          )),
      SizedBox(
        height: screenHeight(context) * 0.017,
        child: InkWell(
          onTap: () {
            projectController.isSearching.value = false;
            projectController.searchedNote.value = '';
            notesSearchController.text = '';
            projectController.update();
          },
          child: projectController.isSearching.value
              ? Icon(
                  Icons.search,
                  size: 26,
                  color: checkThemeColorwhite54,
                )
              : Icon(
                  Icons.search,
                  size: 26,
                  color: checkThemeColorwhite54,
                ),
        ),
      ),
    ],
  );
}

Obx commentsSectionWidget(BuildContext context,
    ProjectController projectController, ScrollController? scrollController) {
  return Obx(
    () {
      return SizedBox(
        height: screenHeight(context) * 0.55,
        width: screenWidth(context) * 0.3,
        child: projectController.comments.isEmpty
            ? Center(
                child: txt(txt: 'Add comments here', fontSize: 14),
              )
            : searchedNotesListViewBuilder(
                context,
                scrollController,
                projectController,
              ),
      );
    },
  );
}

String getFileType(String filePath) {
  final mimeType = lookupMimeType(filePath);
  if (mimeType != null) {
    if (mimeType.startsWith('image/')) {
      return 'image';
    } else if (mimeType.startsWith('video/')) {
      return 'video';
    } else if (mimeType == 'application/pdf') {
      return 'pdf';
    } else {
      return 'other';
    }
  }
  return 'unknown';
}

String getFileName(String filePath) {
  return basename(filePath);
}

Obx commentBox(
    BuildContext context,
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    StateSetter setState,
    Future<void> Function() attachFile,
    ProjectController projectController) {
  final AuthController authController = Get.find();
  return Obx(() {
    return Container(
      width: screenWidth(context) * 0.2,
      height: screenHeight(context) * 0.2,
      decoration: authController.isDarkTheme.value
          ? darkThemeBoxDecoration
          : lightThemeBoxDecoration,
      child: Column(
        children: [
          commentTextfieldWidget(
              commentController, submitComment, attachFile, projectController),
          projectController.commentFiles.isNotEmpty
              ? filePreviewInCommentBoxWidget(
                  context, projectController.commentFiles)
              : Container()
        ],
      ),
    );
  });
}

Expanded filePreviewInCommentBoxWidget(
    BuildContext context, List<File> commentFiles) {
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
        itemCount: commentFiles.length,
        itemBuilder: (BuildContext context, int index) {
          final file = commentFiles[index];
          return SizedBox(
              height: screenHeight(context) * 0.1,
              width: screenWidth(context) * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: getFileType(file.path) == 'image'
                          ? Image.file(file)
                          : Container(
                              color: const Color(mainColor),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txt(
                                    txt: getFileName(file.path),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12),
                              )),
                            ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              commentFiles.removeAt(index);
                            },
                            child: Container(
                                color: Colors.black45,
                                child: const Icon(Icons.close))))
                  ],
                ),
              ));
        },
      ),
    ),
  );
}

Expanded commentTextfieldWidget(
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    Future<void> Function() attachFile,
    ProjectController projectController) {
  final formKey = GlobalKey<FormState>();
  return Expanded(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            if (event.isShiftPressed) {
              commentController!.value = TextEditingValue(
                text: '${commentController.text}\n',
                selection: TextSelection.collapsed(
                  offset: commentController.text.length + 2,
                ),
              );
            } else {
              if (formKey.currentState!.validate()) {
                submitComment();
                Future.delayed(const Duration(milliseconds: 50), () {
                  String trimmedValue = commentController!.text;
                  if (trimmedValue.length >= 5) {
                    commentController.clear();
                  }
                });
              }
            }
          }
        },
        child: Form(
          key: formKey,
          child: TextFormField(
            maxLines: null,
            onEditingComplete: () {},
            textInputAction: TextInputAction.emergencyCall,
            controller: commentController,
            validator: (value) {
              if (value!.length < 5) {
                return 'Comment must contain at least 5 characters';
              } else {
                return null;
              }
            },
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  color: checkThemeColorwhite54,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
            ),
            decoration: InputDecoration(
              suffixIcon: SizedBox(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Builder(builder: (context) {
                      return InkWell(
                        onTap: () {
                          attachFile();
                        },
                        child: Icon(
                          Icons.attach_file,
                          color: checkThemeColorwhite54,
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () {
                        submitComment();
                        Future.delayed(const Duration(milliseconds: 50), () {
                          String trimmedValue = commentController!.text;
                          if (trimmedValue.length >= 5) {
                            commentController.clear();
                          }
                        });
                      },
                      child: Icon(
                        Icons.send,
                        color: checkThemeColorwhite54,
                      ),
                    ),
                  ],
                ),
              ),
              border: InputBorder.none,
              hintText: 'Add Comment...',
              hintStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  letterSpacing: 0,
                  color: checkThemeColorwhite54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Column isNotSearchingColumn(
    BoxConstraints constraints,
    ProjectController? projectController,
    ScrollController? scrollController,
    BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: screenHeight(context) * 0.03,
      ),
      Obx(() {
        return SizedBox(
            height: screenHeight(context) * 0.55,
            child: projectController!.comments.isEmpty
                ? Center(
                    child: txt(txt: 'Add comments here', fontSize: 14),
                  )
                : notesListViewBuilder(
                    context, scrollController, projectController));
      }),
    ],
  );
}

ScrollConfiguration notesListViewBuilder(BuildContext context,
    ScrollController? scrollController, ProjectController projectController) {
  return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
          controller: scrollController,
          itemCount: projectController.comments.length,
          itemBuilder: (context, i) {
            String? comment = projectController.comments[i].comment;
            String? type = projectController.comments[i].type;
            String? username = projectController.comments[i].username;

            DateTime created = !kIsWeb
                ? projectController.comments[i].createdAt!
                : (projectController.comments[i].createdAt as Timestamp)
                    .toDate();

            String firstChar = '';

            for (int i = 0; i < username!.length; i++) {
              firstChar += username[i];
            }

            if (projectController.commentsFilter.value == 1) {
              return usersMsg(context,
                  created: created,
                  username: username,
                  nameFirstChar: firstChar[0],
                  type: type,
                  files: projectController.comments[i].fileNameAndDownloadUrl,
                  comment: comment);
            } else if (projectController.commentsFilter.value == 2) {
              return projectController.comments[i].type.toString() == 'text'
                  ? usersMsg(context,
                      created: created,
                      username: username,
                      nameFirstChar: firstChar[0],
                      type: type,
                      files:
                          projectController.comments[i].fileNameAndDownloadUrl,
                      comment: comment)
                  : Container();
            } else {
              return projectController.comments[i].type.toString() != 'text'
                  ? usersMsg(context,
                      created: created,
                      username: username,
                      nameFirstChar: firstChar[0],
                      type: type,
                      files:
                          projectController.comments[i].fileNameAndDownloadUrl,
                      comment: comment)
                  : Container();
            }
          }));
}

ScrollConfiguration searchedNotesListViewBuilder(
  BuildContext context,
  ScrollController? scrollController,
  ProjectController projectController,
) {
  return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
          controller: scrollController,
          itemCount: projectController.comments.length,
          itemBuilder: (context, i) {
            String comment = projectController.comments[i].comment ?? '';
            String type = projectController.comments[i].type ?? '';
            String username = projectController.comments[i].username ?? '';

            var created = !kIsWeb
                ? projectController.comments[i].createdAt
                : (projectController.comments[i].createdAt as Timestamp)
                    .toDate();

            String firstChar = '';

            for (int i = 0; i < username.length; i++) {
              firstChar += username[i];
            }
            String lowerCaseSearchedNote =
                projectController.searchedNote.value.toLowerCase();
            String lowerCaseComment = comment.toLowerCase();
            if (lowerCaseComment.contains(lowerCaseSearchedNote)) {
              return Expanded(
                child: usersMsg(context,
                    created: created,
                    nameFirstChar: firstChar[0],
                    type: type,
                    files: projectController.comments[i].fileNameAndDownloadUrl,
                    comment: comment),
              );
            } else {
              return Container();
            }
          }));
}
