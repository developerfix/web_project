import 'package:get/get.dart';
import 'package:projectx/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

int _value = 1;

Future<dynamic> addAssetPopUp(BuildContext context) {
  final pathController = TextEditingController();

  final projectController = Get.put(ProjectController());
  final _uid = AuthController.instance.user!.uid;

  final _formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              content: SizedBox(
                height: screenHeight(context) * 0.4,
                width: screenWidth(context) * 0.3,
                child: Padding(
                  padding: constraints.maxWidth < 800
                      ? EdgeInsets.all(8.0)
                      : EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    txt(
                      txt: 'ADD ASSET',
                      fontSize: constraints.maxWidth < 800 ? 20 : 40,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.015,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Row(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Radio(
                        //             value: 1,
                        //             groupValue: _value,
                        //             onChanged: (val) {}),
                        //         SizedBox(
                        //           width: screenWidth(context) * 0.005,
                        //         ),
                        //         txt(txt: 'WEB', fontSize: 20)
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       width: screenWidth(context) * 0.02,
                        //     ),
                        //     Row(
                        //       children: [
                        //         Radio(
                        //             value: 2,
                        //             groupValue: _value,
                        //             onChanged: (val) {}),
                        //         SizedBox(
                        //           width: screenWidth(context) * 0.005,
                        //         ),
                        //         txt(txt: 'FOLDER', fontSize: 20)
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        constraints.maxWidth < 1200
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  txt(
                                    txt: 'Path:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  popUpTextField(context,
                                      controller: pathController, hint: '...'),
                                ],
                              )
                            : Row(
                                children: [
                                  txt(
                                    txt: 'Path:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.02,
                                  ),
                                  popUpTextField(context,
                                      controller: pathController, hint: '...'),
                                ],
                              ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: constraints.maxWidth < 1000
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: constraints.maxWidth < 1200
                                ? screenHeight(context) * 0.08
                                : screenWidth(context) * 0.05,
                            height: screenHeight(context) * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF958890),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.23),
                                  offset: const Offset(0, 3.0),
                                  blurRadius: 9.0,
                                ),
                              ],
                            ),
                            child: Center(
                                child: txt(
                                    txt: 'Cancel',
                                    fontSize: 15,
                                    fontColor: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Get.back();
                              projectController.addNewAsset(
                                path: pathController.text.trim(),
                              );
                            }
                          },
                          child: Container(
                            width: constraints.maxWidth < 1200
                                ? screenHeight(context) * 0.08
                                : screenWidth(context) * 0.05,
                            height: screenHeight(context) * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF958890),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.23),
                                  offset: const Offset(0, 3.0),
                                  blurRadius: 9.0,
                                ),
                              ],
                            ),
                            child: Center(
                                child: txt(
                                    txt: 'Add',
                                    fontSize: 15,
                                    fontColor: Colors.white)),
                          ),
                        ),
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
      });
}
