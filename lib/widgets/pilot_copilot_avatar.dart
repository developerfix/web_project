import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';
import 'cached_image.dart';

Widget projectPilotCopilotAvatar(
    ProjectController projectController, BuildContext context,
    {required String imageUrl}) {
  return projectController.currentProject.value.lead != null &&
          projectController.currentProject.value.leadID != null &&
          projectController.currentProject.value.leadID!.isNotEmpty &&
          projectController.currentProject.value.lead!.isNotEmpty &&
          projectController.getProfileUrlFromUID(
                  projectController.currentProject.value.leadID!) !=
              ''
      ? cachedImage(
          context,
          fontSize: 16,
          isUploading: false,
          isAppBar: false,
          isDrawer: false,
          maxRadius: 20,
          url: projectController.getProfileUrlFromUID(
              projectController.currentProject.value.leadID!),
        )
      : CircleAvatar(
          backgroundColor: const Color(secondaryColor),
          maxRadius: 20,
          child: Center(
            child: txt(
                txt: projectController.currentProject.value.lead != null &&
                        projectController.currentProject.value.lead!.isNotEmpty
                    ? projectController.currentProject.value.lead![0]
                        .toUpperCase()
                    : 'U',
                fontSize: 16,
                fontColor: Colors.white),
          ),
        );
}

Widget taskPilotCopilotAvatar(
    ProjectController projectController, BuildContext context,
    {String? imageUrl}) {
  return imageUrl != null &&
          imageUrl.isNotEmpty &&
          projectController.getProfileUrlFromUID(imageUrl) != ''
      ? cachedImage(
          context,
          fontSize: 16,
          isUploading: false,
          isAppBar: false,
          isDrawer: false,
          maxRadius: 20,
          url: projectController.getProfileUrlFromUID(imageUrl),
        )
      : Container();
}
