import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/models/department.dart';
import 'package:get/get.dart';
import 'package:ava/models/project.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/style.dart';

class DepartmentController extends GetxController {
  Rx<Department> currentDepartment = Department().obs;

  Rx<int> iconCodeValue = 0xe1a3.obs;

  RxList<Project> projects = <Project>[].obs;
  RxBool isFetchingDepartments = false.obs;
  RxBool isRecentDepartmentsListAtTop = true.obs;
  Rx<String> searchedDepartment = "".obs;
  RxList<Department> searchedDepartments = <Department>[].obs;
  RxBool isSearchingDepartment = false.obs;

  getSearchedDepartments() async {
    final ProfileController profileController = Get.find<ProfileController>();
    searchedDepartments.clear();

    for (var dep in profileController.departments) {
      String departmentTitle = dep.title!;

      String lowerCaseSearchedDepartment =
          searchedDepartment.value.toLowerCase();
      String lowerCaseDepartment = departmentTitle.toLowerCase();
      if (lowerCaseDepartment.contains(lowerCaseSearchedDepartment)) {
        searchedDepartments.add(dep);
      }
    }
  }

  getDepartmentInfo(String uid, String departmentId) async {
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(uid)
          .collection('departments')
          .document(departmentId)
          .get()
          .then((value) {
        currentDepartment.value = Department.fromSnap(value);
      });

      update();
    } else {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('departments')
          .doc(departmentId)
          .get()
          .then((value) {
        currentDepartment.value = Department.fromDocSnap(value);
      });

      update();
    }
  }

  void newDepartment({String? title, String? uid, dynamic created}) async {
    ProfileController profileController = Get.find<ProfileController>();
    String departmentId = '';
    Department department = Department(
        departmentId: departmentId,
        title: title,
        createdAt: created,
        iconCode: iconCodeValue.value);

    if (!kIsWeb) {
      try {
        await firedartFirestore
            .collection('users')
            .document('$uid')
            .collection('departments')
            .add(department.toJson())
            .then((value) async {
          department.departmentId = value.id;

          profileController.departments.add(department);
          profileController.update();
          Get.back();

          await firedartFirestore
              .collection('users')
              .document('$uid')
              .collection('departments')
              .document(value.id)
              .update({'departmentId': value.id});
        });
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      try {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('departments')
            .add(department.toJson())
            .then((value) async {
          departmentId = value.id;
          profileController.departments.add(department);
          profileController.update();
          Get.back();
          await firestore
              .collection('users')
              .doc(uid)
              .collection('departments')
              .doc(value.id)
              .update({'departmentId': value.id});
        });
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }
}
