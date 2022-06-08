import 'package:get/get.dart';
import 'package:projectx/models/project.dart';

import '../constants/style.dart';

class ProjectController extends GetxController {
  void registerUser({title, subtitle, uid}) async {
    try {
      Project project = Project(
          copilot: 'assign co-pilot',
          lead: 'assign lead',
          projectId: '42',
          subtitle: subtitle,
          title: title);
      await firestore
          .collection('projects')
          .add(project.toJson())
          .then((value) {
        firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .add(project.toJson());
      });

      getSuccessSnackBar("Project created successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }
}
