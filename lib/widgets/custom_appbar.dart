import 'package:ava/widgets/profile_avatar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../controllers/profile_controller.dart';

AppBar customAppBar(BuildContext context,
    {Widget? title,
    bool? isNeedAppbar,
    String? pageName,
    bool? shouldRefreshTasks}) {
  return AppBar(
    backgroundColor: const Color(mainColor),
    leadingWidth: screenWidth(context) * 0.6,
    leading: GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) => Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: !kIsWeb
                  ? Row(
                      children: [
                        isNeedAppbar == null
                            ? InkWell(
                                onTap: (() {
                                  Get.back();
                                }),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.arrow_back_sharp),
                                ),
                              )
                            : Container(),
                        logoWidget()
                      ],
                    )
                  : logoWidget()),
          SizedBox(
            width: screenWidth(context) * 0.01,
          ),
          pageName != null
              ? Expanded(
                  child: txt(
                    txt: pageName.toUpperCase(),
                    fontSize: 20,
                    maxLines: 1,
                    fontColor: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                )
              : Container(),
        ],
      ),
    ),
    centerTitle: true,
    title: title ?? Container(),
    actions: [
      Expanded(child: MoveWindow()),
      GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) => Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Builder(
            builder: (context) => InkWell(
              onTap: () {
                controller.isNotesDrawer.value = false;
                controller.update();
                Scaffold.of(context).openEndDrawer();
              },
              child: profileAvatar(context, isAppBar: true),
            ),
          ),
        ),
      ),
      MinimizeWindowButton(colors: titleBarButtonColors),
      MaximizeWindowButton(
        colors: titleBarButtonColors,
      ),
      CloseWindowButton(
        colors: titleBarClosingButtonColors,
      )
    ],
  );
}

AppBar authscreenCustomAppBar(BuildContext context,
    {Widget? title,
    bool? isNeedAppbar,
    bool? isAuthScreen,
    String? pageName,
    bool? shouldRefreshTasks}) {
  return AppBar(
    backgroundColor: const Color(mainColor),
    leadingWidth: screenWidth(context) * 0.3,
    leading: Row(
      children: [
        Padding(padding: const EdgeInsets.only(left: 30), child: logoWidget()),
      ],
    ),
    centerTitle: true,
    title: title ?? Container(),
    actions: [
      Expanded(child: MoveWindow()),
      MinimizeWindowButton(colors: titleBarButtonColors),
      MaximizeWindowButton(
        colors: titleBarButtonColors,
      ),
      CloseWindowButton(
        colors: titleBarClosingButtonColors,
      )
    ],
  );
}

Image logoWidget() {
  return Image.asset(
    'assets/images/logoMini.png',
    height: 25,
    color: Colors.white,
  );
}
