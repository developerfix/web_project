import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:projectx/models/project.dart';

import '../constants/style.dart';

class ProjectController extends GetxController {
  final Rx<Map<String, dynamic>> _project = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get project => _project.value;

  RxBool isUploading = false.obs;
  RxBool isAssetUpdating = false.obs;
  RxList<dynamic> comments = <dynamic>[].obs;
  RxList<dynamic> assets = <dynamic>[].obs;
  RxList<dynamic> users = <dynamic>[].obs;

  Rx<String> _uid = "".obs;
  Rx<String> _projectId = "".obs;

  updateProjectAndUserId({String? uid, String? projectId}) {
    _uid.value = uid!;
    _projectId.value = projectId!;
    getProjectData();
    getUsers();
  }

  getProjectAssets() async {
    assets.clear();
    QuerySnapshot projectAssets = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .collection('assets')
        .get();

    for (var asset in projectAssets.docs) {
      assets.add((asset.data() as dynamic));
    }
  }

  getUsers() async {
    await firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var user in querySnapshot.docs) {
        users.add((user.data() as dynamic));
      }
    });
  }

  deleteProjectAsset({path}) async {
    isAssetUpdating.value = true;

    assets.clear();
    await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .collection('assets')
        .where('path', isEqualTo: path)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    getProjectAssets();
    isAssetUpdating.value = false;
  }

  getProjectData() async {
    DocumentSnapshot projectDataDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .get();

    getProjectAssets();
    getProjectComments();

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
    isAssetUpdating.value = true;
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('assets')
          .add({"type": type, "path": path});

      getProjectAssets();
      isAssetUpdating.value = false;

      getSuccessSnackBar("asset added successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  getProjectComments() async {
    QuerySnapshot projectComments = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('projects')
        .doc(_projectId.value)
        .collection('comments')
        .get();

    for (var comment in projectComments.docs) {
      comments.add((comment.data() as dynamic));
    }
  }

  void addNewCommentFile({uid, projectId, username}) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: false);

      UploadTask uploadTask;

      if (result != null) {
        isUploading.value = true;
        // List<File> files = result.files.single.map((files) => File(path!)).toList();
        // List<File> filesNames =
        //     result.names.map((name) => File(name!)).toList();

        Uint8List? uploadfile = result.files.single.bytes;

        String filename = result.files.single.name;

        final ref =
            FirebaseStorage.instance.ref().child('commentFiles/$filename');
        uploadTask = ref.putData(uploadfile!);
        final snapshot = await uploadTask.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        await firestore
            .collection('users')
            .doc(uid)
            .collection('projects')
            .doc(projectId)
            .collection('comments')
            .add({
          "type": 'file',
          "comment": urlDownload,
          "username": username
        }).then((value) {
          comments.add(
              {"type": 'file', "comment": urlDownload, "username": username});
          isUploading.value = false;
        });

        // for (var file in files) {
        //   for (var name in filesNames) {
        //     print(name);

        //     final ref =
        //         FirebaseStorage.instance.ref().child('commentFiles/$name');
        //     uploadTask = ref.putFile(file);
        //     final snapshot = await uploadTask.whenComplete(() {});
        //     final urlDownload = await snapshot.ref.getDownloadURL();
        //     final type = file.uri;

        //     print('type');
        //     print(type);
        //     print(urlDownload);

        //     // await firestore
        //     //     .collection('users')
        //     //     .doc(uid)
        //     //     .collection('projects')
        //     //     .doc(projectId)
        //     //     .collection('comments')
        //     //     .add({"type": 'file', "comment": urlDownload});
        //   }
        // }

        getSuccessSnackBar("comment added successfully");
      } else {
        // User canceled the picker
      }
    } catch (e) {
      isUploading.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  addNewComment({uid, projectId, comment, username}) async {
    isUploading.value = true;
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('comments')
          .add({"type": 'text', "comment": comment, "username": username}).then(
              (value) {
        comments
            .add({"type": 'text', "comment": comment, "username": username});
        isUploading.value = false;
      });

      getSuccessSnackBar("comment added successfully");
    } catch (e) {
      isUploading.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }
}
