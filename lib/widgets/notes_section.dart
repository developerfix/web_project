import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/usersmsg.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'comntbox_file_preview_widget.dart';
import 'loading_indicator.dart';

final formKey = GlobalKey<FormState>();
bool isBeingDragged = false;
Widget notesSection(BoxConstraints constraints, BuildContext context,
    {ScrollController? scrollController,
    required ProjectController projectController,
    ProfileController? profileController,
    required TextEditingController commentController}) {
  submitComment() async {
    String trimmedValue = commentController.text.trim();
    if (trimmedValue.length >= 5) {
      if (projectController.commentFiles.isNotEmpty) {
        await projectController.addNewCommentFile(
          username: profileController!.currentUser.value.name,
          created: DateTime.now(),
          comment: trimmedValue,
          result: projectController.commentFiles,
        );
      } else {
        if (trimmedValue.isNotEmpty) {
          await projectController.addNewComment(
            comment: trimmedValue,
            username: profileController!.currentUser.value.name,
            created: DateTime.now(),
          );
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController!.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  attachFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, allowMultiple: true);
    if (result != null) {
      for (var result in result.files) {
        projectController.commentFiles.add(File(result.path!));
      }
    }
  }

  return screenWidth(context) > 1500
      ? Expanded(
          flex: 2,
          child: notesWidget(projectController, constraints, scrollController,
              commentController, submitComment, attachFile))
      : SizedBox(
          width: 500,
          child: Drawer(
              child: notesWidget(
                  projectController,
                  constraints,
                  scrollController,
                  commentController,
                  submitComment,
                  attachFile)),
        );
}

GetBuilder<ProfileController> notesWidget(
    ProjectController projectController,
    BoxConstraints constraints,
    ScrollController? scrollController,
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    Future<void> Function() attachFile) {
  return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.currentUser.value.name!.isEmpty) {
          return const LoadingIndicator();
        } else {
          return StatefulBuilder(builder: (context, setState) {
            return DropTarget(
                onDragDone: (detail) {
                  setState(() {
                    projectController.commentFiles
                        .addAll(detail.files.map((xFile) => File(xFile.path)));
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
                    padding: const EdgeInsets.fromLTRB(50, 30, 30, 80),
                    child: isBeingDragged
                        ? isBeingDraggedWidget(
                            context,
                            projectController,
                            constraints,
                            scrollController,
                            commentController,
                            submitComment,
                            setState,
                            attachFile)
                        : notBeingDraggedWidget(
                            context,
                            projectController,
                            constraints,
                            scrollController,
                            commentController,
                            submitComment,
                            setState,
                            attachFile)));
          });
        }
      });
}

Obx notBeingDraggedWidget(
    BuildContext context,
    ProjectController projectController,
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
          searchTextFieldAndFilterWidget(
            context,
            projectController: projectController,
          ),
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
    BoxConstraints constraints,
    ScrollController? scrollController,
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    StateSetter setState,
    Future<void> Function() attachFile) {
  final AuthController authController = Get.find<AuthController>();
  return Stack(
    children: [
      Column(children: [
        searchTextFieldAndFilterWidget(
          context,
          projectController: projectController,
        ),
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

Row searchTextFieldAndFilterWidget(
  BuildContext context, {
  ProjectController? projectController,
  ScrollController? scrollController,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(child: searchNotesWidget(context, projectController!)),
      const Icon(
        Icons.search,
        size: 26,
      ),
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
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      } else if (value == 2) {
        projectController.commentsFilter.value = 2;
        projectController.update();
      } else {
        projectController.commentsFilter.value = 3;
        projectController.update();
        scrollController?.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
    child: const Icon(
      Icons.filter_alt_outlined,
      size: 26,
    ),
  );
}

TextField searchNotesWidget(
  BuildContext context,
  ProjectController projectController,
) {
  return TextField(
    onChanged: ((value) {
      if (value.isNotEmpty) {
        projectController.isSearching.value = true;
        projectController.searchedNote.value = value;
      } else {
        projectController.isSearching.value = false;
      }
    }),
    maxLines: 1,
    decoration: InputDecoration(
      hintStyle: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          overflow: TextOverflow.visible,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
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
  final AuthController authController = Get.find<AuthController>();
  return Obx(() {
    return Container(
      // width: screenWidth(context) * 0.2,
      height: screenHeight(context) * 0.2,
      decoration: authController.isDarkTheme.value
          ? darkThemeBoxDecoration
          : lightThemeBoxDecoration,
      child: Column(
        children: [
          commentTextfieldWidget(
              commentController, submitComment, attachFile, projectController),
          projectController.commentFiles.isNotEmpty
              ? FilePreviewInCommentBoxWidget(projectController.commentFiles)
              : Container()
        ],
      ),
    );
  });
}

Expanded commentTextfieldWidget(
    TextEditingController? commentController,
    Future<void> Function() submitComment,
    Future<void> Function() attachFile,
    ProjectController projectController) {
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
            controller: commentController,
            validator: (value) {
              if (value!.length < 5) {
                return 'Comment must contain at least 5 characters';
              } else {
                return null;
              }
            },
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
            ),
            decoration: InputDecoration(
              // enabledBorder: InputBorder.none,
              // disabledBorder: InputBorder.none,
              // focusedBorder: InputBorder.none,
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
                        child: const Icon(
                          Icons.attach_file,
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          submitComment();
                          Future.delayed(const Duration(milliseconds: 50), () {
                            String trimmedValue = commentController!.text;
                            if (trimmedValue.length >= 5) {
                              commentController.clear();
                            }
                          });
                        }
                      },
                      child: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
              ),
              border: InputBorder.none,
              hintText: 'Add Comment...',
              hintStyle: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  overflow: TextOverflow.visible,
                  letterSpacing: 0,
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
            String? profileUrl = projectController.comments[i].profileUrl;

            DateTime created = projectController.comments[i].createdAt!;

            String firstChar = '';

            for (int i = 0; i < username!.length; i++) {
              firstChar += username[i];
            }

            if (projectController.commentsFilter.value == 1) {
              return usersMsg(context,
                  created: created,
                  username: username,
                  profileUrl: profileUrl,
                  nameFirstChar: firstChar[0],
                  type: type,
                  files: projectController.comments[i].fileNameAndDownloadUrl,
                  comment: comment);
            } else if (projectController.commentsFilter.value == 2) {
              return projectController.comments[i].type.toString() == 'text'
                  ? usersMsg(context,
                      created: created,
                      username: username,
                      profileUrl: profileUrl,
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
            String profileUrl = projectController.comments[i].profileUrl ?? '';

            var created = projectController.comments[i].createdAt;

            String firstChar = '';

            for (int i = 0; i < username.length; i++) {
              firstChar += username[i];
            }
            String lowerCaseSearchedNote =
                projectController.searchedNote.value.toLowerCase();
            String lowerCaseComment = comment.toLowerCase();
            if (lowerCaseComment.contains(lowerCaseSearchedNote)) {
              return usersMsg(context,
                  created: created,
                  username: username,
                  profileUrl: profileUrl,
                  nameFirstChar: firstChar[0],
                  type: type,
                  files: projectController.comments[i].fileNameAndDownloadUrl,
                  comment: comment);
            } else {
              return Container();
            }
          }));
}
