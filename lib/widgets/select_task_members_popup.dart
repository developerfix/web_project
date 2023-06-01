import 'package:ava/widgets/add_new_task_popup.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

Future<dynamic> selectTaskMembersPopup(BuildContext context,
    {String? title, List? listOfMembers, required bool isUser}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: screenHeight(context) * 0.5,
            width: 1000,
            child: Column(
              children: [
                popupHeader(title!),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      Obx(() {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: listOfMembers!.length,
                            itemBuilder: (context, i) {
                              String username = isUser
                                  ? listOfMembers[i]['name']
                                  : listOfMembers[i]['username'];
                              return ListTile(
                                leading: const Icon(
                                  Icons.person,
                                ),
                                title: txt(
                                    txt: username,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                                onTap: () {
                                  Get.back(result: [
                                    listOfMembers[i]['username'],
                                    listOfMembers[i]['uid']
                                  ]);
                                },
                              );
                            });
                      }),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
