import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:ava/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';
import 'asset_catagory_widgets.dart';

Future<dynamic> addLinkAssetPopUp(BuildContext context) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();
  final categoryTitleController = TextEditingController();
  final ProjectController projectController = Get.find<ProjectController>();
  projectController.selectedAssetFiles.clear();
  final AuthController authController = Get.find<AuthController>();
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
                  width: 1000,
                  child: Column(
                    children: [
                      popUpCloseButton,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: <Widget>[
                            txt(
                              txt: 'ADD HYPERLINK',
                              font: 'comfortaa',
                              fontSize: 40,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w700,
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth(context) * 0.15,
                                          child: txt(
                                            minFontSize: 18,
                                            maxLines: 1,
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.04,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth(context) * 0.15,
                                          child: txt(
                                            minFontSize: 18,
                                            maxLines: 1,
                                            txt: 'Suggested name for URL:',
                                            fontSize: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth(context) * 0.02,
                                        ),
                                        popUpTextField(context,
                                            controller: pathNameController,
                                            hint: 'exp: Youtube news section'),
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
