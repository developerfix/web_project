import 'package:get/get.dart';
import 'package:projectx/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

Future<dynamic> selectTaskMembersPopup(BuildContext context, {String? title}) {
  final projectController = Get.put(ProjectController());

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: screenHeight(context) * 0.5,
            width: screenWidth(context) * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: <Widget>[
                txt(
                  txt: title!,
                  fontSize: 24,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: screenHeight(context) * 0.015,
                ),
                SizedBox(
                  height: screenHeight(context) * 0.4,
                  width: screenWidth(context) * 0.25,
                  child: Obx(() {
                    return ListView.builder(
                        itemCount: projectController.users.length,
                        itemBuilder: (context, i) {
                          String username = projectController.users[i]['name'];
                          return screenWidth(context) < 600
                              ? InkWell(
                                  onTap: () {
                                    Get.back(result: username);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: txt(
                                        txt: username,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )
                              : ListTile(
                                  leading: const Icon(
                                    Icons.person,
                                  ),
                                  title: txt(
                                      txt: username,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis),
                                  onTap: () {
                                    Get.back(result: username);
                                  },
                                );
                        });
                  }),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.005,
                )
              ]),
            ),
          ),
        );
      });
}
