import 'package:ava/models/department.dart';
import 'package:ava/pages/projects_grid.dart';
import 'package:get/get.dart';
import 'package:ava/models/project.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/style.dart';

class DepartmentController extends GetxController {
  Rx<Department> currentDepartment = Department().obs;

  Rx<int> iconCodeValue = 0xe1a3.obs;
  RxList<Department> departments = <Department>[].obs;
  RxList<Project> projects = <Project>[].obs;
  RxBool isFetchingDepartments = false.obs;
  RxBool isRecentDepartmentsListAtTop = true.obs;
  Rx<String> searchedDepartment = "".obs;
  RxBool isSearchingDepartment = false.obs;

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

  void newDepartment({
    String? title,
    String? uid,
  }) async {
    String departmentId = '';
    Department department = Department(
        departmentId: departmentId,
        title: title,
        iconCode: iconCodeValue.value);

    if (!kIsWeb) {
      try {
        await firedartFirestore
            .collection('users')
            .document('$uid')
            .collection('departments')
            .add(department.toJson())
            .then((value) async {
          departmentId = value.id;
          await firedartFirestore
              .collection('users')
              .document('$uid')
              .collection('departments')
              .document(value.id)
              .update({'departmentId': value.id}).then((value) async {
            Get.to(() => ProjectsGrid(departmentId: departmentId));
          });
        });

        getSuccessSnackBar("Department created successfully");
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
          await firestore
              .collection('users')
              .doc(uid)
              .collection('departments')
              .doc(value.id)
              .update({'departmentId': value.id}).then((value) async {
            Get.to(() => ProjectsGrid(departmentId: departmentId));
          });
        });

        getSuccessSnackBar("Department created successfully");
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }
}
