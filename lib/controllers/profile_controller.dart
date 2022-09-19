import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  RxList<dynamic> projects = <dynamic>[].obs;
  RxBool isFetchingProjects = false.obs;

  final Rx<String> _uid = "".obs;

  updateUserData(String uid) {
    _uid.value = uid;
    getUserData();
    getProjects();
  }

  getUserData() async {
    dynamic userDoc;

    if (!kIsWeb) {
      userDoc = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .get();

      String name = userDoc['name'];
      String profilePhoto = userDoc['profilePhoto'];
      String email = userDoc['email'];
      int noOfProjects = userDoc['noOfProjects'];

      _user.value = {
        'profilePhoto': profilePhoto,
        'name': name,
        'email': email,
        'noOfProjects': noOfProjects,
      };
      update();
    } else {
      userDoc = await firestore.collection('users').doc(_uid.value).get();

      final userData = userDoc.data()! as dynamic;
      String name = userData['name'];
      String profilePhoto = userData['profilePhoto'];
      String email = userData['email'];
      int noOfProjects = userData['noOfProjects'];

      _user.value = {
        'profilePhoto': profilePhoto,
        'name': name,
        'email': email,
        'noOfProjects': noOfProjects,
      };
      update();
    }
  }

  getProjects() async {
    isFetchingProjects.value = true;
    projects.clear();

    if (!kIsWeb) {
      var documents = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .get();

      for (var document in documents) {
        projects.add(document);
      }
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('projects')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var project in querySnapshot.docs) {
          projects.add((project.data() as dynamic));
        }
      });
    }

    isFetchingProjects.value = false;
  }
}
