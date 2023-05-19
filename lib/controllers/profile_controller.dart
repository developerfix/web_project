import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dart/storage.dart' as firebase_dart_storage;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../constants/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/department.dart';
import '../models/project.dart';
import '../models/user.dart';

class ProfileController extends GetxController {
  Rx<User> currentUser = User().obs;

  RxBool isFetchingProjects = false.obs;
  RxBool isProfileUploading = false.obs;
  RxBool isFetchingDepartments = false.obs;
  RxBool isNotesDrawer = false.obs;

  RxList<Department> departments = <Department>[].obs;

  RxList<Project> departmentProjects = <Project>[].obs;
  //projectCategories
  RxList<String> projectCategories = <String>[].obs;
  Rx<String> projectCategory = "".obs;
  final Rx<String> _uid = "".obs;
  // ignore: prefer_typing_uninitialized_variables
  var app;
  updateUserData(
    String uid,
  ) {
    _uid.value = uid;

    getUserData();
  }

  editName(String newName) async {
    currentUser.value.name = newName;
    update();
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .update({'name': newName});
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .update({'name': newName});
    }
  }

  updateLastOpenedProject(
    String projectId,
    String departmentId,
  ) async {
    currentUser.value.lastOpenedProjectId = projectId;
    currentUser.value.lastOpenedDocumentId = departmentId;
    update();
    if (!kIsWeb) {
      await firedartFirestore.collection('users').document(_uid.value).update({
        'lastOpenedProjectId': projectId,
        'lastOpenedDocumentId': departmentId
      });
    } else {
      await firestore.collection('users').doc(_uid.value).update({
        'lastOpenedProjectId': projectId,
        'lastOpenedDocumentId': departmentId
      });
    }
  }

  String getFileName(String filePath) {
    return basename(filePath);
  }

  profilePhotoUpdate({File? result}) async {
    isProfileUploading.value = true;
    Uint8List? file = result!.readAsBytesSync();
    String fileName = getFileName(result.path);

    try {
      var storage = firebase_dart_storage.FirebaseStorage.instanceFor(app: app);
      var ref = storage.ref().child("profilePhotos/$fileName").putData(file);

      ref.snapshotEvents.listen((event) {
        if (event.state == firebase_dart_storage.TaskState.success) {
          event.ref.getDownloadURL().then((downloadUrl) async {
            isProfileUploading.value = false;
            currentUser.value.profilePhoto = downloadUrl;
            update();

            if (!kIsWeb) {
              firedartFirestore
                  .collection('users')
                  .document(_uid.value)
                  .update({'profilePhoto': downloadUrl});
            } else {
              firestore
                  .collection('users')
                  .doc(_uid.value)
                  .update({'profilePhoto': downloadUrl});
            }
          });
        }
      });
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  getUserData() async {
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .get()
          .then((value) {
        currentUser.value = User.fromDoc(value);
      });
    } else {
      await firestore.collection('users').doc(_uid.value).get().then((value) {
        currentUser.value = User.fromDocumentSnapshot(value);
      });
    }
    update();
  }

  getDepartments() async {
    isFetchingDepartments.value = true;
    departments.clear();

    if (!kIsWeb) {
      var documents = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('departments')
          .orderBy(
            'createdAt',
          )
          .get();

      for (var document in documents) {
        departments.add(Department.fromSnap(document));
      }
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('departments')
          .orderBy(
            'createdAt',
          )
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var department in querySnapshot.docs) {
          departments.add(Department.fromQuerySnap(department));
        }
      });
    }

    isFetchingDepartments.value = false;
  }

  getDepartmentProjects(String departmentId) async {
    isFetchingProjects.value = true;
    departmentProjects.clear();

    List<String> tempCats = [];
    projectCategories.clear();

    if (!kIsWeb) {
      var documents = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('departments')
          .document(departmentId)
          .collection('projects')
          .orderBy(
            'lastOpened',
          )
          .get();

      for (var document in documents) {
        departmentProjects.add(Project.fromSnap(document));
      }
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('departments')
          .doc(departmentId)
          .collection('projects')
          .orderBy(
            'lastOpened',
          )
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var project in querySnapshot.docs) {
          departmentProjects.add(Project.fromQuerySnap(project));
        }
      });
    }

    isFetchingProjects.value = false;

    for (var projcategory in departmentProjects) {
      tempCats.add(projcategory.category!);
    }
    projectCategories.value = [
      ...{...tempCats}
    ];

    projectCategories.add(newProjectCategory);
    if (!projectCategories.contains(designCategory)) {
      projectCategories.add(designCategory);
    }
    if (!projectCategories.contains(opticalCategory)) {
      projectCategories.add(opticalCategory);
    }
  }
}
