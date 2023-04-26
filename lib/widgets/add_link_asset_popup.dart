import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:ava/widgets/popup_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

Future<dynamic> addLinkAssetPopUp(BuildContext context) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();
  final categoryTitleController = TextEditingController();
  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  final formKey = GlobalKey<FormState>();

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
                              txt: 'ADD HYPERLINK',
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
                                              hint:
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
                                              hint:
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
                                                  hint:
                                                      'https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw'),
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
                                                  hint:
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
                                popupButton(context, ontap: () {
                                  if (formKey.currentState!.validate()) {
                                    bool validURL =
                                        Uri.parse(pathController.text)
                                            .isAbsolute;
                                    if (pathController.text
                                        .contains('https://')) {
                                      if (validURL) {
                                        Get.back();
                                        projectController.addNewAsset(
                                            path: pathController.text.trim(),
                                            type: linkAssetType,
                                            pathName:
                                                pathNameController.text.trim(),
                                            assetCategoryTitle:
                                                projectController.assetCategory
                                                            .value ==
                                                        newAssetCategory
                                                    ? categoryTitleController
                                                    : projectController
                                                        .assetCategory.value);
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
                                        projectController.addNewAsset(
                                            path: pathController.text.trim(),
                                            type: linkAssetType,
                                            pathName:
                                                pathNameController.text.trim(),
                                            assetCategoryTitle:
                                                projectController.assetCategory
                                                            .value ==
                                                        newAssetCategory
                                                    ? categoryTitleController
                                                        .text
                                                    : projectController
                                                        .assetCategory.value);
                                      } else {
                                        getErrorSnackBar(
                                            'Please enter a valid url path');
                                      }
                                    }
                                  }
                                }, text: 'Add'),
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
