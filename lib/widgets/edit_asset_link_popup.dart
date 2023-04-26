import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:ava/widgets/popup_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';

Future<dynamic> editAssetLinkPopUp(BuildContext context,
    {String? path, String? pathName, String? assetID}) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();
  final categoryTitleController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  height: screenHeight(context) *
                      (projectController.assetCategory.value == newAssetCategory
                          ? 0.6
                          : 0.5),
                  width: screenWidth(context) * 0.5,
                  child: Column(
                    children: [
                      popUpCloseButton,
                      Expanded(
                        child: Padding(
                          padding: screenWidth(context) < 800
                              ? const EdgeInsets.all(8.0)
                              : const EdgeInsets.all(20.0),
                          child: Column(children: <Widget>[
                            txt(
                              txt: 'EDIT ASSET',
                              font: 'comfortaa',
                              fontSize: screenWidth(context) < 800 ? 20 : 40,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w700,
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                screenWidth(context) < 1200
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenWidth(context) * 0.15,
                                            child: txt(
                                              txt: 'URL Path:',
                                              fontSize: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth(context) * 0.02,
                                          ),
                                          popUpTextField(context,
                                              controller: pathController,
                                              hint: path ??
                                                  'https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw'),
                                          SizedBox(
                                            width: screenWidth(context) * 0.03,
                                          ),
                                          SizedBox(
                                            width: screenWidth(context) * 0.15,
                                            child: txt(
                                              txt: 'Suggested name for URL:',
                                              fontSize: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth(context) * 0.02,
                                          ),
                                          popUpTextField(context,
                                              controller: pathController,
                                              hint: pathName ??
                                                  'exp: Youtube news section'),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.15,
                                                child: txt(
                                                  txt: 'URL Path:',
                                                  fontSize: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.02,
                                              ),
                                              popUpTextField(context,
                                                  controller: pathController,
                                                  hint: path ??
                                                      'https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw'),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.05,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.15,
                                                child: txt(
                                                  txt:
                                                      'Suggested name for URL:',
                                                  fontSize: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.02,
                                              ),
                                              popUpTextField(context,
                                                  controller:
                                                      pathNameController,
                                                  hint: pathName ??
                                                      'exp: Youtube news section'),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.04,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.15,
                                                child: txt(
                                                  txt: 'Category:',
                                                  fontSize: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    screenWidth(context) * 0.02,
                                              ),
                                              Container(
                                                width:
                                                    screenWidth(context) * 0.2,
                                                height: screenHeight(context) *
                                                    0.05,
                                                decoration: authController
                                                        .isDarkTheme.value
                                                    ? darkThemeBoxDecoration
                                                    : lightThemeBoxDecoration,
                                                child: Center(
                                                  child:
                                                      DropdownButtonFormField(
                                                    // itemHeight: 15,
                                                    // menuMaxHeight: 30,
                                                    items: <String>[
                                                      noCategory,
                                                      newAssetCategory
                                                    ].map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),

                                                    onChanged: (value) {
                                                      setState(() {
                                                        projectController
                                                                .assetCategory
                                                                .value =
                                                            value.toString();
                                                        projectController
                                                            .update();
                                                      });
                                                    },
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        letterSpacing: 0,
                                                        color: brownishColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      hintStyle: GoogleFonts
                                                          .montserrat(
                                                        textStyle:
                                                            const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          letterSpacing: 0,
                                                          color: brownishColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      hintText:
                                                          projectController
                                                              .assetCategory
                                                              .value,
                                                      fillColor: authController
                                                              .isDarkTheme.value
                                                          ? Colors.black12
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          projectController
                                                      .assetCategory.value ==
                                                  newAssetCategory
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height: screenHeight(
                                                              context) *
                                                          0.04,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: screenWidth(
                                                                  context) *
                                                              0.15,
                                                          child: txt(
                                                            txt:
                                                                'New category title',
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth(
                                                                  context) *
                                                              0.02,
                                                        ),
                                                        popUpTextField(context,
                                                            controller:
                                                                categoryTitleController,
                                                            hint:
                                                                'exp: Media files'),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.04,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: screenWidth(context) < 1000
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                popupButton(
                                  context,
                                  text: 'Edit',
                                  ontap: () {
                                    if (pathNameController.text.isEmpty &&
                                        pathController.text.isEmpty &&
                                        categoryTitleController.text.isEmpty &&
                                        projectController.assetCategory.value ==
                                            newAssetCategory) {
                                      getErrorSnackBar(
                                          "Please make some changes first");
                                    } else {
                                      bool validURL =
                                          Uri.parse(pathController.text)
                                              .isAbsolute;
                                      if (pathController.text.isNotEmpty) {
                                        if (pathController.text
                                            .contains('https://')) {
                                          if (validURL) {
                                            Get.back();

                                            projectController.editAsset(
                                                assetID: assetID,
                                                type: linkAssetType,
                                                path: pathController
                                                        .text.isEmpty
                                                    ? path
                                                    : pathController.text
                                                        .trim(),
                                                pathName: pathNameController
                                                        .text.isEmpty
                                                    ? pathName
                                                    : pathNameController.text
                                                        .trim(),
                                                assetCategoryTitle:
                                                    projectController
                                                                .assetCategory
                                                                .value ==
                                                            newAssetCategory
                                                        ? categoryTitleController
                                                            .text
                                                        : projectController
                                                            .assetCategory
                                                            .value);
                                          } else {
                                            getErrorSnackBar(
                                                'Please enter a valid url path');
                                          }
                                        } else {
                                          pathController.text =
                                              'https://${pathController.text}';

                                          bool validURL =
                                              Uri.parse(pathController.text)
                                                  .isAbsolute;

                                          if (validURL) {
                                            Get.back();

                                            projectController.editAsset(
                                                assetID: assetID,
                                                type: linkAssetType,
                                                path: pathController
                                                        .text.isEmpty
                                                    ? path
                                                    : pathController.text
                                                        .trim(),
                                                pathName: pathNameController
                                                        .text.isEmpty
                                                    ? pathName
                                                    : pathNameController.text
                                                        .trim(),
                                                assetCategoryTitle:
                                                    projectController
                                                                .assetCategory
                                                                .value ==
                                                            newAssetCategory
                                                        ? categoryTitleController
                                                            .text
                                                        : projectController
                                                            .assetCategory
                                                            .value);
                                          } else {
                                            getErrorSnackBar(
                                                'Please enter a valid url path');
                                          }
                                        }
                                      } else {
                                        Get.back();

                                        projectController.editAsset(
                                            assetID: assetID,
                                            type: linkAssetType,
                                            path: pathController.text.isEmpty
                                                ? path
                                                : pathController.text.trim(),
                                            pathName:
                                                pathNameController.text.isEmpty
                                                    ? pathName
                                                    : pathNameController.text
                                                        .trim(),
                                            assetCategoryTitle:
                                                projectController.assetCategory
                                                            .value ==
                                                        newAssetCategory
                                                    ? categoryTitleController
                                                        .text
                                                    : projectController
                                                        .assetCategory.value);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.005,
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
