import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projectx/models/project.dart';

import '../constants/style.dart';

class ProjectController extends GetxController {
  final Rx<Map<String, dynamic>> _project = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get project => _project.value;

  Rx<String> _uid = "".obs;
  Rx<String> _projectId = "".obs;

  updateProjectAndUserId({String? uid, String? projectId}) {
    _uid.value = uid!;
    _projectId.value = projectId!;
    getProjectData();
  }

  getProjectData() async {
    DocumentSnapshot projectDataDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .get();

    QuerySnapshot projectAssets = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .collection('assets')
        .get();

    for (var asset in projectAssets.docs) {
      print(asset['path']);
    }

    final projectData = projectDataDoc.data()! as dynamic;
    String title = projectData['title'];
    String subtitle = projectData['subtitle'];
    String lead = projectData['lead'];
    String copilot = projectData['copilot'];

    _project.value = {
      'title': title,
      'subtitle': subtitle,
      'lead': lead,
      'copilot': copilot,
    };
    update();
  }

  void newProject({title, subtitle, uid, projectId}) async {
    try {
      Project project = Project(
          copilot: 'assign co-pilot',
          lead: 'assign lead',
          projectId: projectId,
          subtitle: subtitle,
          title: title);
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .set(project.toJson());

      getSuccessSnackBar("Project created successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  void addNewAsset({type, path, uid, projectId}) async {
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('assets')
          .add({"type": type, "path": path});

      getSuccessSnackBar("asset added successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }
}
