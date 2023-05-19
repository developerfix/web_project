import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';

Future<dynamic> selectFromUsersPopup(BuildContext context, {String? title}) {
  final ProjectController projectController = Get.find<ProjectController>();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: screenHeight(context) * 0.5,
            width: screenWidth(context) * 0.3,
            child: Column(
              children: [
                popUpCloseButton,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      txt(
                        txt: title!,
                        fontSize: 24,
                        font: 'comfortaa',
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.015,
                      ),
                      Expanded(
                        child: Obx(() {
                          return ListView.builder(
                              itemCount: projectController.users.length,
                              itemBuilder: (context, i) {
                                String username =
                                    projectController.users[i].name!;
                                return ListTile(
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
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
