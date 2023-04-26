import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dart/storage.dart' as firebase_dart_storage;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../constants/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_dart/core.dart' as firebase_dart;
import '../models/department.dart';
import '../models/project.dart';
import '../models/user.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  Rx<User> currentUser = User().obs;

  RxBool isFetchingProjects = false.obs;
  RxBool isProfileUploading = false.obs;
  Rx<double> profilePhotoUploadProgress = 0.0.obs;
  RxBool isFetchingDepartments = false.obs;
  RxBool isProfilePhotoUpdating = false.obs;
  RxList<Department> departments = <Department>[].obs;
  RxList<Project> departmentProjects = <Project>[].obs;

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

  String getFileName(String filePath) {
    return basename(filePath);
  }

  profilePhotoUpdate({File? result}) async {
    isProfileUploading.value = true;
    Uint8List? file = result!.readAsBytesSync();
    String fileName = getFileName(result.path);
    String? urlDownload;

    try {
      var storage = firebase_dart_storage.FirebaseStorage.instanceFor(app: app);
      var ref = storage.ref().child("files/$fileName").putData(file);

      ref.snapshotEvents.listen((event) {
        profilePhotoUploadProgress.value =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                100);
        if (event.state == firebase_dart_storage.TaskState.success) {
          event.ref.getDownloadURL().then((downloadUrl) async {
            urlDownload = downloadUrl;

            currentUser.value.profilePhoto = urlDownload;

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
    isProfileUploading.value = false;
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

      update();
    } else {
      await firestore.collection('users').doc(_uid.value).get().then((value) {
        currentUser.value = User.fromDocumentSnapshot(value);
      });

      update();
    }
  }

  getDepartments() async {
    isFetchingDepartments.value = true;
    departments.clear();

    if (!kIsWeb) {
      var documents = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('departments')
          .get();

      for (var document in documents) {
        departments.add(Department.fromSnap(document));
      }
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('departments')
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

    if (!kIsWeb) {
      var documents = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('departments')
          .document(departmentId)
          .collection('projects')
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
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var project in querySnapshot.docs) {
          departmentProjects.add(Project.fromQuerySnap(project));
        }
      });
    }

    isFetchingProjects.value = false;
  }
}
