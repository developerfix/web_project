import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:ava/controllers/department_controller.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/models/asset.dart';
import 'package:ava/widgets/notes_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:ava/models/project.dart';
import 'package:ava/models/project_member.dart';
import 'package:ava/models/task.dart' as task_model;
import 'package:ava/pages/project_dashboard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/style.dart';
import 'package:firebase_dart/storage.dart' as firebase_dart_storage;

import '../models/comment.dart';
import '../models/task.dart';
import '../models/user.dart';

class ProjectController extends GetxController {
  Rx<Project> currentProject = Project().obs;

  RxBool isSelectedDeliverablesUpdatingBefore = false.obs;
  RxBool isSelectedDeliverablesUpdatingAfter = false.obs;

  RxBool isSearching = false.obs;
  RxBool isTasksUpdating = false.obs;
  RxBool isTaskDateUpdating = false.obs;
  RxBool isMembersUpdating = false.obs;

  RxBool isRecentProjectsListAtTop = true.obs;
//
  Rx<String> searchedProject = "".obs;
  RxBool isSearchingProject = false.obs;
  RxList<Project> searchedProjects = <Project>[].obs;
  RxList<String> searchedProjectsCategories = <String>[].obs;
  //comment
  RxList<Comment> comments = <Comment>[].obs;
  RxList<File> commentFiles = <File>[].obs;
  //asset
  RxList<Asset> assets = <Asset>[].obs;
  RxList<String> assetsCategories = <String>[].obs;
  Rx<String> assetCategory = "".obs;
//task phases/categories
  RxList<String> taskCategories = <String>[].obs;
  Rx<String> taskCategory = "".obs;
  //
  RxList<User> users = <User>[].obs;
  RxList<dynamic> projectMembers = <dynamic>[].obs;
  RxList<task_model.Task> toDoTasks = <task_model.Task>[].obs;
  RxList<task_model.Task> inProgressTasks = <task_model.Task>[].obs;
  RxList<task_model.Task> completedTasks = <task_model.Task>[].obs;
  RxList<dynamic> selectedDeliverables = <dynamic>[].obs;
  RxList<dynamic> selectedAssetFiles = <dynamic>[].obs;
  final uploadProgress = {}.obs;
  final selectedAssetFilesUploadProgress = {}.obs;
  Rx<double> progress = 0.0.obs;
  Rx<int> commentsFilter = 1.obs;
  Rx<int> taskPrioritySelectedValue = 2.obs;
  Rx<int> taskSelectedValue = 2.obs;
  Rx<double> deliverableUplaodingProgress = 0.0.obs;
  Rx<double> assetFileUplaodingProgress = 0.0.obs;

  Rx<String> searchedNote = "".obs;
  Rx<String> taskPilot = "".obs;
  Rx<String> taskCoPilot = "".obs;

  final Rx<String> uuid = "".obs;
  final Rx<String> _projectId = "".obs;
  final Rx<String> deepartmentId = "".obs;
  // ignore: prefer_typing_uninitialized_variables
  var app;

  updateProject({
    String? projectId,
    String? uid,
    String? departmentId,
  }) {
    _projectId.value = projectId!;
    uuid.value = uid!;
    deepartmentId.value = departmentId!;

    getProjectData();
  }

  getSearchedProjectsCategories() async {
    final ProfileController profileController = Get.find<ProfileController>();

    searchedProjectsCategories.clear();

    for (var proj in profileController.departmentProjects) {
      String lowerCaseSearchedProject = searchedProject.value.toLowerCase();
      String lowerCaseProject = proj.title!.toLowerCase();
      if (lowerCaseProject.contains(lowerCaseSearchedProject)) {
        searchedProjectsCategories.add(proj.category!);
      }
    }
    searchedProjectsCategories.value =
        searchedProjectsCategories.toSet().toList();
  }

  getSearchedProjects(String category) async {
    final ProfileController profileController = Get.find<ProfileController>();

    searchedProjects.clear();

    for (var proj in profileController.departmentProjects) {
      String lowerCaseSearchedProject = searchedProject.value.toLowerCase();
      String lowerCaseProject = proj.title!.toLowerCase();

      if (lowerCaseProject.contains(lowerCaseSearchedProject)) {
        for (var element in profileController.departmentProjects) {
          if (element.title == proj.title && element.category == category) {
            searchedProjects.add(proj);
          }
        }
      }
    }
  }

  getProjectAssets() async {
    List<String> tempCats = [];
    assets.clear();
    assetsCategories.clear();
    if (!kIsWeb) {
      var projectAssets = await firedartFirestore
          .collection('users')
          .document(uuid.value)
          .collection('departments')
          .document(deepartmentId.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('assets')
          .orderBy('created', descending: true)
          .get();

      for (var asset in projectAssets) {
        assets.add(Asset.fromSnap(asset));
      }
    } else {
      QuerySnapshot projectAssets = await firestore
          .collection('users')
          .doc(uuid.value)
          .collection('departments')
          .doc(deepartmentId.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('assets')
          .orderBy('created', descending: true)
          .get();

      for (var asset in projectAssets.docs) {
        assets.add((Asset.fromQuerySnap(asset)));
      }
    }
    for (var asset in assets) {
      tempCats.add(asset.assetCategory!);
    }

    assetsCategories.value = [
      ...{...tempCats}
    ];
    assetsCategories.add(newAssetCategory);
    if (!assetsCategories.contains(noCategory)) {
      assetsCategories.add(noCategory);
    }
  }

  getProfileUrlFromUID(String uid) {
    String profileUrl = '';
    for (var user in users) {
      if (user.uid == uid) {
        profileUrl = user.profilePhoto!;
      }
    }
    return profileUrl;
  }

  getProjectMembers() async {
    projectMembers.clear();
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(uuid.value)
          .collection('departments')
          .document(deepartmentId.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('members')
          .get()
          .then((members) {
        for (var member in members) {
          projectMembers.add(member);
        }
      });
    } else {
      await firestore
          .collection('users')
          .doc(uuid.value)
          .collection('departments')
          .doc(deepartmentId.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('members')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var member in querySnapshot.docs) {
          var memberr = (member.data() as dynamic);
          projectMembers.add(memberr);
        }
      });
    }
  }

  getUsers() async {
    users.clear();
    if (!kIsWeb) {
      var fetchedUsers = await firedartFirestore.collection('users').get();

      for (var user in fetchedUsers) {
        users.add(User.fromDoc(user));
      }
    } else {
      await firestore
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var user in querySnapshot.docs) {
          users.add(User.fromDocumentSnapshot(user));
        }
      });
    }
  }

  editCategoryName(
      {required String newName, required String oldCategoryName}) async {
    List<Asset> listOfAssets = [];
    for (var asset in assets) {
      if (asset.assetCategory == oldCategoryName) {
        listOfAssets.add(asset);
        asset.assetCategory = newName;
      }
    }
    update();

    for (var asset in listOfAssets) {
      if (!kIsWeb) {
        await firedartFirestore
            .collection('users')
            .document(uuid.value)
            .collection('departments')
            .document(deepartmentId.value)
            .collection('projects')
            .document(_projectId.value)
            .collection('assets')
            .document(asset.assetID!)
            .update({'assetCategory': newName});
      } else {
        await firestore
            .collection('users')
            .doc(uuid.value)
            .collection('departments')
            .doc(deepartmentId.value)
            .collection('projects')
            .doc(_projectId.value)
            .collection('assets')
            .doc(asset.assetID!)
            .update({'assetCategory': newName});
      }
    }
  }

  deleteProjectAsset({assetID}) async {
    FutureGroup futureGroup = FutureGroup();
    assets.removeWhere((element) => element.assetID == assetID);
    update();
    if (!kIsWeb) {
      for (var i = 0; i < projectMembers.length; i++) {
        futureGroup.add(firedartFirestore
            .collection('users')
            .document(projectMembers[i]['uid'])
            .collection('departments')
            .document(deepartmentId.value)
            .collection('projects')
            .document(_projectId.value)
            .collection('assets')
            .document(assetID)
            .delete());
      }
    } else {
      for (var i = 0; i < projectMembers.length; i++) {
        futureGroup.add(firestore
            .collection('users')
            .doc(projectMembers[i]['uid'])
            .collection('departments')
            .doc(deepartmentId.value)
            .collection('projects')
            .doc(_projectId.value)
            .collection('assets')
            .doc(assetID)
            .delete());
      }
    }
  }

  deleteProjectTask({taskID, status}) async {
    FutureGroup futureGroup = FutureGroup();
    try {
      status == todo
          ? toDoTasks.removeWhere((element) => element.taskID == taskID)
          : status == inProgress
              ? inProgressTasks
                  .removeWhere((element) => element.taskID == taskID)
              : completedTasks
                  .removeWhere((element) => element.taskID == taskID);
      update();
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .delete());
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .delete());
        }
      }
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addToInProgress(
      {String? taskTitle,
      String? phase,
      required String taskID,
      String? taskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      String? daysToComplete,
      List? taskDeliverables,
      int? priorityLevel,
      int? deliverablesRequiredOrNot}) async {
    FutureGroup futureGroup = FutureGroup();
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskID: taskID,
        taskDescription: taskDescription,
        daysToComplete: daysToComplete,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: inProgress,
        requiredDeliverables: null,
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        deliverables: taskDeliverables,
        priorityLevel: priorityLevel);

    try {
      status == todo
          ? toDoTasks.removeWhere((element) => element.taskID == taskID)
          : completedTasks.removeWhere((element) => element.taskID == taskID);

      inProgressTasks.add(task);
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': inProgress}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': inProgress}));
        }
      }
      futureGroup.close();
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addToTodo(
      {String? taskTitle,
      String? phase,
      required String taskID,
      String? taskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? daysToComplete,
      String? status,
      List? taskDeliverables,
      int? priorityLevel,
      int? deliverablesRequiredOrNot}) async {
    FutureGroup futureGroup = FutureGroup();
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        taskID: taskID,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        daysToComplete: daysToComplete,
        status: todo,
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        deliverables: taskDeliverables,
        requiredDeliverables: null,
        priorityLevel: priorityLevel);
    try {
      status == inProgress
          ? inProgressTasks.removeWhere((element) => element.taskID == taskID)
          : completedTasks.removeWhere((element) => element.taskID == taskID);

      toDoTasks.add(task);
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': todo}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': todo}));
        }
      }
      futureGroup.close();
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addToCompleted(
      {String? taskTitle,
      required String taskID,
      String? phase,
      String? taskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? daysToComplete,
      String? status,
      List? taskDeliverables,
      List? requiredDeliverables,
      int? priorityLevel,
      int? deliverablesRequiredOrNot}) async {
    FutureGroup futureGroup = FutureGroup();
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        taskID: taskID,
        daysToComplete: daysToComplete,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        deliverables: taskDeliverables,
        requiredDeliverables: requiredDeliverables,
        status: completed,
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        priorityLevel: priorityLevel);
    try {
      status == todo
          ? toDoTasks.removeWhere((element) => element.taskID == taskID)
          : inProgressTasks.removeWhere((element) => element.taskID == taskID);

      completedTasks.add(task);
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': completed}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': completed}));
        }
      }
      futureGroup.close();
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong in addToCompleted, Please try again",
      );
    }
  }

  getProjectData() async {
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(uuid.value)
          .collection('departments')
          .document(deepartmentId.value)
          .collection('projects')
          .document(_projectId.value)
          .get()
          .then((value) {
        currentProject.value = Project.fromSnap(value);
      });

      getProjectMembers();
      getProjectAssets();
      getProjectComments();
      getProjectTasks();

      update();
    } else {
      await firestore
          .collection('users')
          .doc(uuid.value)
          .collection('departments')
          .doc(deepartmentId.value)
          .collection('projects')
          .doc(_projectId.value)
          .get()
          .then((value) {
        currentProject.value = Project.fromDocSnap(value);
      });

      getProjectMembers();
      getProjectAssets();
      getProjectComments();
      getProjectTasks();

      update();
    }
  }

  void updateProjectLastOpenedParameter({
    dynamic lastOpened,
    required String projectId,
    required String uid,
    required String deepartmentId,
  }) async {
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(uid)
          .collection('departments')
          .document(deepartmentId)
          .collection('projects')
          .document(projectId)
          .update({'lastOpened': lastOpened}).then((value) async {
        Get.to(() => ProjectDashboard(
              projectId: projectId,
            ));
      });
    } else {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('departments')
          .doc(deepartmentId)
          .collection('projects')
          .doc(projectId)
          .update({'lastOpened': lastOpened}).then((value) async {
        Get.to(() => ProjectDashboard(
              projectId: projectId,
            ));
      });
    }
  }

  void newProject({
    String? title,
    String? subtitle,
    dynamic lastOpened,
    String? uid,
    String? username,
    String? catergory,
  }) async {
    final DepartmentController departmentController =
        Get.find<DepartmentController>();
    ProfileController profileController = Get.find<ProfileController>();
    FutureGroup futureGroup = FutureGroup();
    String projectId = '';
    Project project = Project(
        copilot: '',
        lead: '',
        leadID: '',
        copilotID: '',
        lastOpened: lastOpened,
        projectId: projectId,
        subtitle: subtitle,
        category: catergory,
        title: title);

    if (!kIsWeb) {
      try {
        await firedartFirestore
            .collection('users')
            .document('$uid')
            .collection('departments')
            .document(
                departmentController.currentDepartment.value.departmentId!)
            .collection('projects')
            .add(project.toJson())
            .then((value) async {
          project.projectId = value.id;

          profileController.departmentProjects.add(project);
          profileController.update();

          Get.back();

          await firedartFirestore
              .collection('users')
              .document('$uid')
              .collection('departments')
              .document(
                  departmentController.currentDepartment.value.departmentId!)
              .collection('projects')
              .document(value.id)
              .update({'projectId': value.id}).then((value) async {
            futureGroup.add(firedartFirestore
                .collection('users')
                .document('$uid')
                .collection('departments')
                .document(
                    departmentController.currentDepartment.value.departmentId!)
                .collection('projects')
                .document(project.projectId!)
                .collection('members')
                .document(profileController.currentUser.value.uid!)
                .set({
              "uid": profileController.currentUser.value.uid,
              'username': profileController.currentUser.value.name
            }));
          });
        });
        futureGroup.close();
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
            .doc(departmentController.currentDepartment.value.departmentId!)
            .collection('projects')
            .add(project.toJson())
            .then((value) async {
          project.projectId = value.id;

          profileController.departmentProjects.add(project);
          profileController.update();

          Get.back();

          await firestore
              .collection('users')
              .doc(uid)
              .collection('departments')
              .doc(departmentController.currentDepartment.value.departmentId!)
              .collection('projects')
              .doc(value.id)
              .update({'projectId': value.id}).then((value) async {
            futureGroup.add(firestore
                .collection('users')
                .doc('$uid')
                .collection('departments')
                .doc(departmentController.currentDepartment.value.departmentId!)
                .collection('projects')
                .doc(project.projectId!)
                .collection('members')
                .doc(profileController.currentUser.value.uid!)
                .set({
              "uid": profileController.currentUser.value.uid,
              'username': profileController.currentUser.value.name
            }));
          });
        });
        futureGroup.close();
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  void updatingPilotCopilot({
    String? pilot,
    String? copilot,
    List<ProjectMember>? projectMembers,
  }) async {
    FutureGroup futureGroup = FutureGroup();
    Get.back();
    if (!kIsWeb) {
      try {
        for (var projectMember in projectMembers!) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document('${projectMember.uid}')
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('members')
              .document('${projectMember.uid}')
              .set({
            "uid": projectMember.uid,
            'username': projectMember.username
          }));
        }
        futureGroup.close();
      } catch (e) {
        //define error

        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      // try {

      //       for (var projectMember in initialProjectMembers!) {
      //         futureGroup.add(firestore
      //             .collection('users')
      //             .doc('$uid')
      //             .collection('departments')
      //             .doc(deepartmentId.value)
      //             .collection('projects')
      //             .doc(projectId)
      //             .collection('members')
      //             .doc('${projectMember.uid}')
      //             .set({
      //           "uid": projectMember.uid,
      //           'username': projectMember.username
      //         }));
      //       }
      //       futureGroup.close();

      //    getSuccessSnackBar("Members updated successfully");
      // } catch (e) {
      //   //define error
      //   getErrorSnackBar(
      //     "Something went wrong, Please try again",
      //   );
      // }
    }
  }

  void addNewAsset({type, path, pathName, assetCategoryTitle}) async {
    FutureGroup futureGroup = FutureGroup();
    String assetID = '';
    if (!assetsCategories.contains(assetCategoryTitle)) {
      assetsCategories.add(assetCategoryTitle);
    }

    if (!kIsWeb) {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(member['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .add({}).then((value) {
            assetID = value.id;
            Asset asset = Asset(
                assetCategory: assetCategoryTitle,
                assetID: assetID,
                created: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString()
                    .substring(0, 10),
                path: path,
                type: type,
                pathName: pathName);

            assets.insert(0, asset);
            update();

            firedartFirestore
                .collection('users')
                .document(member['uid'])
                .collection('departments')
                .document(deepartmentId.value)
                .collection('projects')
                .document(_projectId.value)
                .collection('assets')
                .document(value.id)
                .set(asset.toJson());
          }));
        }

        futureGroup.close();
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firestore
              .collection('users')
              .doc(member['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .add({}).then((value) {
            assetID = value.id;
            Asset asset = Asset(
                assetCategory: assetCategoryTitle,
                assetID: assetID,
                created: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString()
                    .substring(0, 10),
                path: path,
                type: type,
                pathName: pathName);
            assets.insert(0, asset);
            update();
            firestore
                .collection('users')
                .doc(member['uid'])
                .collection('departments')
                .doc(deepartmentId.value)
                .collection('projects')
                .doc(_projectId.value)
                .collection('assets')
                .doc(value.id)
                .set(asset.toJson());
          }));
        }
        futureGroup.close();
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  void editAsset({type, path, pathName, assetID, assetCategoryTitle}) async {
    FutureGroup futureGroup = FutureGroup();
    if (!assetsCategories.contains(assetCategoryTitle)) {
      assetsCategories.add(assetCategoryTitle);
    }
    assets.removeWhere((element) => element.assetID == assetID);
    Asset asset = Asset(
        assetCategory: assetCategoryTitle,
        assetID: assetID,
        type: type,
        created:
            DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10),
        path: path,
        pathName: pathName);
    assets.insert(0, asset);
    update();

    if (!kIsWeb) {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(member['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .document(assetID)
              .update(asset.toJson()));
        }
        futureGroup.close();
        update();
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firestore
              .collection('users')
              .doc(member['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .doc(assetID)
              .update(asset.toJson()));
        }
        futureGroup.close();
        update();
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  getProjectComments() async {
    comments.clear();
    if (!kIsWeb) {
      var projectComments = await firedartFirestore
          .collection('users')
          .document(uuid.value)
          .collection('departments')
          .document(deepartmentId.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('comments')
          .orderBy(
            'createdAt',
          )
          .get();

      for (var comment in projectComments) {
        comments.add(Comment.fromSnap(comment));
      }
    } else {
      QuerySnapshot projectComments = await firestore
          .collection('users')
          .doc(uuid.value)
          .collection('departments')
          .doc(deepartmentId.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('comments')
          .orderBy(
            'createdAt',
          )
          .get();

      for (var comment in projectComments.docs) {
        comments.add(Comment.fromQuerySnap(comment));
      }
    }
  }

  getProjectTasks() async {
    toDoTasks.clear();
    inProgressTasks.clear();
    completedTasks.clear();

    List<String> tempCats = [];
    taskCategories.clear();

    if (!kIsWeb) {
      var projectTasks = await firedartFirestore
          .collection('users')
          .document(uuid.value)
          .collection('departments')
          .document(deepartmentId.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('tasks')
          .get();

      for (var task in projectTasks) {
        if (task['status'] == todo) {
          toDoTasks.add(task_model.Task.fromDocumentSnap(task));
        } else if (task['status'] == inProgress) {
          inProgressTasks.add(task_model.Task.fromDocumentSnap(task));
        } else {
          completedTasks.add(task_model.Task.fromDocumentSnap(task));
        }
      }
    } else {
      QuerySnapshot projectTasks = await firestore
          .collection('users')
          .doc(uuid.value)
          .collection('departments')
          .doc(deepartmentId.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('tasks')
          .get();

      for (var tasks in projectTasks.docs) {
        var task = tasks.data() as dynamic;

        if (task['status'] == todo) {
          toDoTasks.add(task);
        } else if (task['status'] == inProgress) {
          inProgressTasks.add(task);
        } else {
          completedTasks.add(task);
        }
      }
    }

    List<Task> addedTasks = [
      ...toDoTasks,
      ...inProgressTasks,
      ...completedTasks
    ];
    for (var task in addedTasks) {
      tempCats.add(task.phase!);
    }
    taskCategories.value = [
      ...{...tempCats}
    ];

    taskCategories.add(newTaskCategory);
    if (!taskCategories.contains(noPhase)) {
      taskCategories.add(noPhase);
    }
  }

  addNewCommentFile(
      {comment, username, profileUrl, created, List<File>? result}) async {
    uploadProgress.clear();
    try {
      Comment commenttt = Comment();
      List<File> newList = [...result!];
      commentFiles.clear();
      Map fileNameAndDownloadUrl = {};

      Comment commentt = Comment(
          type: 'file',
          comment: comment,
          profileUrl: profileUrl,
          createdAt: created,
          fileNameAndDownloadUrl: fileNameAndDownloadUrl,
          username: username);

      comments.add(commentt);
      update();
      List<Future<void>> uploadFutures = [];
      for (var filee in newList) {
        Uint8List? file = filee.readAsBytesSync();
        String fileName = getFileName(filee.path);
        String urlDownload = '';

        firebase_dart_storage.UploadTask uploadTask =
            firebase_dart_storage.FirebaseStorage.instanceFor(app: app)
                .ref()
                .child("files/$fileName")
                .putData(file);

        uploadTask.snapshotEvents
            .listen((firebase_dart_storage.TaskSnapshot snapshot) async {
          double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
          urlDownload = await snapshot.ref.getDownloadURL();
          fileNameAndDownloadUrl[fileName] = urlDownload;
          int percentage = (progress * 100).round();

          uploadProgress[urlDownload] = percentage;

          update();
        });

        Future<void> uploadFuture =
            uploadTask.then((firebase_dart_storage.TaskSnapshot snapshot) {
          // Do any final processing here
        });

        uploadFutures.add(uploadFuture);
      }

      await Future.wait(uploadFutures);

      commenttt = Comment(
          type: 'file',
          comment: comment,
          profileUrl: profileUrl,
          createdAt: created,
          fileNameAndDownloadUrl: fileNameAndDownloadUrl,
          username: username);

      FutureGroup futureGroup = FutureGroup();
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('comments')
              .add(commenttt.toJson()));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('comments')
              .add(commenttt.toJson()));
        }
      }
      comments.indexWhere((element) {
        if (element.comment == comment && element.createdAt == created) {
          element = commenttt;
        }
        return true;
      });

      update();

      futureGroup.close();
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addTaskDeliverables() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, allowMultiple: true);

    if (result != null) {
      Map<String?, Uint8List?> files = {};

      for (int i = 0; i < result.files.length; i++) {
        files[result.files[i].name] = result.files[i].bytes;
      }

      files.forEach((key, value) {
        String? urlDownload;

        try {
          isSelectedDeliverablesUpdatingBefore.value = true;
          var storage =
              firebase_dart_storage.FirebaseStorage.instanceFor(app: app);
          var ref =
              storage.ref().child("taskDeliverables/$key").putData(value!);

          ref.snapshotEvents.listen((event) {
            isSelectedDeliverablesUpdatingBefore.value = false;
            deliverableUplaodingProgress.value =
                ((event.bytesTransferred.toDouble() /
                        event.totalBytes.toDouble()) *
                    100);
            if (event.state == firebase_dart_storage.TaskState.success) {
              isSelectedDeliverablesUpdatingAfter.value = true;

              event.ref.getDownloadURL().then((downloadUrl) async {
                urlDownload = downloadUrl;

                selectedDeliverables.add({
                  "urlDownload": urlDownload,
                  "filename": event.ref.name,
                });

                isSelectedDeliverablesUpdatingAfter.value = false;
              });
            }
          });
        } catch (e) {
          isSelectedDeliverablesUpdatingBefore.value = false;
          isSelectedDeliverablesUpdatingAfter.value = false;
          //define error
          getErrorSnackBar(
            "Something went wrong, Please try again",
          );
        }
      });
    } else {
      // User canceled the picker
    }
  }

  addFileInAsset() async {
    // selectedAssetFilesUploadProgress.clear();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, allowMultiple: true);

    if (result != null) {
      Map<String?, Uint8List?> files = {};

      for (int i = 0; i < result.files.length; i++) {
        files[result.files[i].name] = result.files[i].bytes;
      }

      files.forEach((key, value) {
        String? urlDownload;

        try {
          firebase_dart_storage.UploadTask uploadTask =
              firebase_dart_storage.FirebaseStorage.instanceFor(app: app)
                  .ref()
                  .child("assetFiles/$key")
                  .putData(value!);
          selectedAssetFiles.add({
            "urlDownload": urlDownload,
            "filename": key,
          });

          uploadTask.snapshotEvents
              .listen((firebase_dart_storage.TaskSnapshot snapshot) async {
            double assetFileUplaodingProgress =
                (snapshot.bytesTransferred / snapshot.totalBytes);
            urlDownload = await snapshot.ref.getDownloadURL();

            int percentage = (assetFileUplaodingProgress * 100).round();

            selectedAssetFilesUploadProgress[key] = percentage;
            for (var element in selectedAssetFiles) {
              if (element['filename'] == key) {
                element['urlDownload'] = urlDownload;
              }
            }

            update();
          });
        } catch (e) {
          //define error
          getErrorSnackBar(
            "Something went wrong, Please try again",
          );
        }
      });
    } else {
      // User canceled the picker
    }
  }

  addNewComment({comment, username, created, profileUrl}) async {
    FutureGroup futureGroup = FutureGroup();

    Comment commentt = Comment(
        type: 'text',
        comment: comment,
        createdAt: created,
        profileUrl: profileUrl,
        fileNameAndDownloadUrl: null,
        username: username);
    comments.add(commentt);
    update();

    if (!kIsWeb) {
      try {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('comments')
              .add(commentt.toJson()));
        }
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      try {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('comments')
              .add(commentt.toJson()));
        }
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  addNewTask(
      {String? taskTitle,
      String? phase,
      String? taskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      int? isDeliverableNeededForCompletion,
      String? daysToComplete,
      String? endDate,
      String? status,
      List? deliverables,
      int? priorityLevel}) async {
    isTasksUpdating.value = true;
    List deliverablesList = [];
    FutureGroup futureGroup = FutureGroup();
    for (var item in deliverables!) {
      deliverablesList.add(item);
    }
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        isDeliverableNeededForCompletion: isDeliverableNeededForCompletion,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        daysToComplete: daysToComplete,
        startDate: startDate,
        requiredDeliverables: null,
        endDate: endDate,
        status: status,
        deliverables: deliverablesList,
        priorityLevel: priorityLevel);

    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .add(task.toJson())
              .then((value) async {
            task_model.Task updatedTaskWithID = task_model.Task(
                taskTitle: taskTitle,
                phase: phase,
                taskID: value.id,
                daysToComplete: daysToComplete,
                isDeliverableNeededForCompletion:
                    isDeliverableNeededForCompletion,
                taskDescription: taskDescription,
                pilot: pilot,
                copilot: copilot,
                startDate: startDate,
                requiredDeliverables: null,
                endDate: endDate,
                status: status,
                deliverables: deliverablesList,
                priorityLevel: priorityLevel);
            if (projectMembers[i]['uid'] == uuid.value) {
              if (status == todo) {
                toDoTasks.add(updatedTaskWithID);
              } else if (status == inProgress) {
                inProgressTasks.add(updatedTaskWithID);
              } else {
                completedTasks.add(updatedTaskWithID);
              }
            }
            firedartFirestore
                .collection('users')
                .document(projectMembers[i]['uid'])
                .collection('departments')
                .document(deepartmentId.value)
                .collection('projects')
                .document(_projectId.value)
                .collection('tasks')
                .document(value.id)
                .update(updatedTaskWithID.toJson());
          }));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .add(task.toJson())
              .then((value) {
            task_model.Task updatedTaskWithID = task_model.Task(
                taskTitle: taskTitle,
                phase: phase,
                taskID: value.id,
                isDeliverableNeededForCompletion:
                    isDeliverableNeededForCompletion,
                taskDescription: taskDescription,
                pilot: pilot,
                copilot: copilot,
                daysToComplete: daysToComplete,
                startDate: startDate,
                requiredDeliverables: null,
                endDate: endDate,
                status: status,
                deliverables: deliverablesList,
                priorityLevel: priorityLevel);
            if (projectMembers[i]['uid'] == uuid.value) {
              if (status == todo) {
                toDoTasks.add(updatedTaskWithID);
              } else if (status == inProgress) {
                inProgressTasks.add(updatedTaskWithID);
              } else {
                completedTasks.add(updatedTaskWithID);
              }
            }

            firestore
                .collection('users')
                .doc(projectMembers[i]['uid'])
                .collection('departments')
                .doc(deepartmentId.value)
                .collection('projects')
                .doc(_projectId.value)
                .collection('tasks')
                .doc(value.id)
                .update(updatedTaskWithID.toJson());
          }));
        }
      }
      futureGroup.close();

      isTasksUpdating.value = false;
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addRequiredTaskDeliverables({
    required String taskID,
    required List requiredDeliverables,
  }) async {
    isTasksUpdating.value = true;
    FutureGroup futureGroup = FutureGroup();

    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'requiredDeliverables': requiredDeliverables}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'requiredDeliverables': requiredDeliverables}));
        }
      }
      futureGroup.close;
      isTasksUpdating.value = false;
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar(
        "Something went wrong in addRequiredTaskDeliverables, Please try again",
      );
    }
  }

  updateTask({
    String? taskTitle,
    required String taskID,
    String? phase,
    String? taskDescription,
    String? pilot,
    String? copilot,
    String? startDate,
    String? daysToComplete,
    String? endDate,
    String? status,
    List? taskDeliverables,
    int? priorityLevel,
    int? isDeliverableNeededForCompletion,
  }) async {
    isTasksUpdating.value = true;
    FutureGroup futureGroup = FutureGroup();
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskID: taskID,
        requiredDeliverables: null,
        taskDescription: taskDescription,
        isDeliverableNeededForCompletion: isDeliverableNeededForCompletion,
        pilot: pilot,
        daysToComplete: daysToComplete,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: status,
        deliverables: taskDeliverables,
        priorityLevel: priorityLevel);

    if (status == todo) {
      toDoTasks.removeWhere((element) => element.taskID == taskID);
      toDoTasks.add(task);
    } else if (status == inProgress) {
      inProgressTasks.removeWhere((element) => element.taskID == taskID);
      inProgressTasks.add(task);
    } else {
      completedTasks.removeWhere((element) => element.taskID == taskID);
      completedTasks.add(task);
    }

    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          if (await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .exists) {
            futureGroup.add(firedartFirestore
                .collection('users')
                .document(projectMembers[i]['uid'])
                .collection('departments')
                .document(deepartmentId.value)
                .collection('projects')
                .document(_projectId.value)
                .collection('tasks')
                .document(taskID)
                .update(task.toJson()));
          }
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .get()
              .then((value) {
            for (var element in value.docs) {
              if (element.id == taskID) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(projectMembers[i]['uid'])
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('tasks')
                    .doc(taskID)
                    .update(task.toJson()));
              }
            }
          });
        }
      }

      futureGroup.close();

      isTasksUpdating.value = false;
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  updateTaskDateFromGanttChart({
    required String taskID,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    FutureGroup futureGroup = FutureGroup();

    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
                  .collection('users')
                  .document(projectMembers[i]['uid'])
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('tasks')
                  .document(taskID)
                  .exists
              ? futureGroup.add(
                  firedartFirestore
                      .collection('users')
                      .document(projectMembers[i]['uid'])
                      .collection('departments')
                      .document(deepartmentId.value)
                      .collection('projects')
                      .document(_projectId.value)
                      .collection('tasks')
                      .document(taskID)
                      .update(
                    {
                      'startDate':
                          '${startDate.year}/${startDate.month}/${startDate.day}',
                      'endDate':
                          '${endDate.year}/${endDate.month}/${endDate.day}',
                    },
                  ),
                )
              : null;
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .get()
              .then((value) {
            for (var element in value.docs) {
              if (element.id == taskID) {
                futureGroup.add(
                  firestore
                      .collection('users')
                      .doc(projectMembers[i]['uid'])
                      .collection('departments')
                      .doc(deepartmentId.value)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('tasks')
                      .doc(taskID)
                      .update(
                    {
                      'startDate':
                          '${startDate.year}/${startDate.month}/${startDate.day}',
                      'endDate':
                          '${endDate.year}/${endDate.month}/${endDate.day}',
                    },
                  ),
                );
              }
            }
          });
        }
      }

      futureGroup.close();
      getProjectTasks();
    } catch (e) {
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  manageProjectMembers({
    List<ProjectMember>? members,
    List<ProjectMember>? removedMembers,
  }) async {
    if (!kIsWeb) {
      FutureGroup futureGroup = FutureGroup();

      isMembersUpdating.value = true;
      var exitedMembersList = [];
      projectMembers.clear();
      try {
        for (var i = 0; i < removedMembers!.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .delete());

          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('comments')
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('members')
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
              .collection('departments')
              .document(deepartmentId.value)
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.delete();
            }
          }));
        }

        await firedartFirestore
            .collection('users')
            .document(uuid.value)
            .collection('departments')
            .document(deepartmentId.value)
            .collection('projects')
            .document(_projectId.value)
            .collection('members')
            .get()
            .then((value) {
          for (var doc in value) {
            exitedMembersList.add(doc.id);
          }
        });

        for (var i = 0; i < members!.length; i++) {
          if (exitedMembersList.contains(members[i].uid!)) {
            futureGroup.add(
              firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .update(
                {
                  'copilot': currentProject.value.copilot,
                  'lead': currentProject.value.lead,
                  'copilotID': currentProject.value.copilotID,
                  'leadID': currentProject.value.leadID,
                },
              ),
            );

            for (var projectMember in members) {
              if (exitedMembersList.contains(projectMember.uid)) {
              } else {
                futureGroup.add(firedartFirestore
                    .collection('users')
                    .document(members[i].uid!)
                    .collection('departments')
                    .document(deepartmentId.value)
                    .collection('projects')
                    .document(_projectId.value)
                    .collection('members')
                    .document(projectMember.uid!)
                    .set({
                  'uid': projectMember.uid,
                  'username': projectMember.username
                }));
              }
            }

            for (var removedMember in removedMembers) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('members')
                  .document(removedMember.uid!)
                  .delete());
            }
          } else {
            futureGroup.add(firedartFirestore
                .collection('users')
                .document(members[i].uid!)
                .collection('departments')
                .document(deepartmentId.value)
                .collection('projects')
                .document(_projectId.value)
                .set(currentProject.value.toJson()));

            for (var member in members) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('members')
                  .document(
                    member.uid!,
                  )
                  .set({'uid': member.uid, 'username': member.username}));
            }

            for (var asset in assets) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('assets')
                  .add(asset.toJson()));
            }

            for (var comment in comments) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('comments')
                  .add(comment.toJson()));
            }

            var tasksList = toDoTasks + inProgressTasks + completedTasks;

            for (var task in tasksList) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('departments')
                  .document(deepartmentId.value)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('tasks')
                  .add(task.toJson()));
            }
          }
        }
        futureGroup.close();
        getProjectData();

        isMembersUpdating.value = false;
      } catch (e) {
        isMembersUpdating.value = false;
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      FutureGroup futureGroup = FutureGroup();

      isMembersUpdating.value = true;
      projectMembers.clear();
      try {
        for (var i = 0; i < removedMembers!.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .delete());

          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('comments')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('members')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          }));
          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          }));
        }

        for (var i = 0; i < members!.length; i++) {
          await firestore
              .collection('users')
              .doc(members[i].uid)
              .collection('departments')
              .doc(deepartmentId.value)
              .collection('projects')
              .doc(_projectId.value)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              futureGroup.add(
                firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .update(
                  {
                    'copilot': currentProject.value.copilot,
                    'lead': currentProject.value.lead,
                    'copilotID': currentProject.value.copilotID,
                    'leadID': currentProject.value.leadID,
                  },
                ),
              );

              for (var projectMember in members) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('members')
                    .doc(projectMember.uid)
                    .get()
                    .then((DocumentSnapshot document) async {
                  if (document.exists) {
                  } else {
                    await firestore
                        .collection('users')
                        .doc(members[i].uid)
                        .collection('departments')
                        .doc(deepartmentId.value)
                        .collection('projects')
                        .doc(_projectId.value)
                        .collection('members')
                        .doc(projectMember.uid)
                        .set({
                      'uid': projectMember.uid,
                      'username': projectMember.username
                    });
                  }
                }));
              }

              for (var removedMember in removedMembers) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('members')
                    .doc(removedMember.uid)
                    .delete());
              }
            } else {
              futureGroup.add(firestore
                  .collection('users')
                  .doc(members[i].uid)
                  .collection('departments')
                  .doc(deepartmentId.value)
                  .collection('projects')
                  .doc(_projectId.value)
                  .set(currentProject.value.toJson()));

              for (var member in members) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('members')
                    .doc(
                      member.uid,
                    )
                    .set({'uid': member.uid, 'username': member.username}));
              }

              for (var asset in assets) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('assets')
                    .add(asset.toJson()));
              }

              for (var comment in comments) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('comments')
                    .add(comment.toJson()));
              }

              var tasksList = toDoTasks + inProgressTasks + completedTasks;

              for (var task in tasksList) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('departments')
                    .doc(deepartmentId.value)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('tasks')
                    .add(task.toJson()));
              }
            }
          });
        }
        futureGroup.close();
        getProjectData();

        isMembersUpdating.value = false;
      } catch (e) {
        isMembersUpdating.value = false;
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }
}
