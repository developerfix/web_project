import 'package:Ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:Ava/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';

Future<dynamic> addAssetPopUp(BuildContext context) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();

  final projectController = Get.put(ProjectController());

  final formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.4,
              width: screenWidth(context) * 0.5,
              child: Padding(
                padding: screenWidth(context) < 800
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  txt(
                    txt: 'ADD ASSET',
                    font: 'comfortaa',
                    fontSize: screenWidth(context) < 800 ? 20 : 40,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.015,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      screenWidth(context) < 1200
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    hint: 'exp: Youtube news section'),
                              ],
                            )
                          : Column(
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
                                        hint:
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
                                        hint: 'exp: Youtube news section'),
                                  ],
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
                        Get.back();
                      }, text: 'Cancel'),
                      SizedBox(
                        width: screenWidth(context) * 0.01,
                      ),
                      popupButton(context, ontap: () {
                        if (formKey.currentState!.validate()) {
                          bool validURL =
                              Uri.parse(pathController.text).isAbsolute;
                          if (pathController.text.contains('https://')) {
                            if (validURL) {
                              Get.back();
                              projectController.addNewAsset(
                                path: pathController.text.trim(),
                                pathName: pathNameController.text.trim(),
                              );
                            } else {
                              getErrorSnackBar('Please enter a valid url path');
                            }
                          } else {
                            pathController.text =
                                'https://${pathController.text}';

                            bool validURL =
                                Uri.parse(pathController.text).isAbsolute;

                            if (validURL) {
                              Get.back();
                              projectController.addNewAsset(
                                path: pathController.text.trim(),
                                pathName: pathNameController.text.trim(),
                              );
                            } else {
                              getErrorSnackBar('Please enter a valid url path');
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
          ),
        );
      });
}
