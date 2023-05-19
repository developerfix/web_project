import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:ava/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';
import 'asset_catagory_widgets.dart';

Future<dynamic> editAssetLinkPopUp(
  BuildContext context, {
  String? path,
  String? pathName,
  String? assetID,
  String? category,
}) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();
  final categoryTitleController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
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
                  width: 1000,
                  child: Column(
                    children: [
                      popUpCloseButton,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: <Widget>[
                            txt(
                              txt: 'EDIT ASSET',
                              font: 'comfortaa',
                              fontSize: 40,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w700,
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Row(
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
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                ),
                                Row(
                                  children: [
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
                                        controller: pathNameController,
                                        hint: pathName ??
                                            'exp: Youtube news section'),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.04,
                                ),
                                categoryDropDown(context, authController,
                                    setState, projectController),
                                projectController.assetCategory.value ==
                                        newAssetCategory
                                    ? newCategoryTextField(
                                        context, categoryTitleController)
                                    : Container(),
                                SizedBox(
                                  height: screenHeight(context) * 0.04,
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
                                            category) {
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
                                                assetCategoryTitle: projectController
                                                            .assetCategory
                                                            .value ==
                                                        newAssetCategory
                                                    ? (categoryTitleController
                                                            .text.isEmpty
                                                        ? 'Category'
                                                        : categoryTitleController
                                                            .text)
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
                                                assetCategoryTitle: projectController
                                                            .assetCategory
                                                            .value ==
                                                        newAssetCategory
                                                    ? (categoryTitleController
                                                            .text.isEmpty
                                                        ? 'Category'
                                                        : categoryTitleController
                                                            .text)
                                                    : projectController
                                                        .assetCategory.value);
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
                                            pathName: pathNameController
                                                    .text.isEmpty
                                                ? pathName
                                                : pathNameController.text
                                                    .trim(),
                                            assetCategoryTitle: projectController
                                                        .assetCategory.value ==
                                                    newAssetCategory
                                                ? (categoryTitleController
                                                        .text.isEmpty
                                                    ? 'Category'
                                                    : categoryTitleController
                                                        .text)
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
