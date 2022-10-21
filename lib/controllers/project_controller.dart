import 'dart:typed_data';

import 'package:async/async.dart';
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
import 'package:firebase_dart/core.dart' as firebase_dart;

class ProjectController extends GetxController {
  final Rx<Map<String, dynamic>> _project = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get project => _project.value;

  RxBool isCommentFileUpdatingBefore = false.obs;
  RxBool isSelectedDeliverablesUpdatingBefore = false.obs;
  RxBool isSelectedDeliverablesUpdatingAfter = false.obs;
  RxBool isCommentFileUpdatingAfter = false.obs;
  RxBool isSearching = false.obs;
  RxBool isTasksUpdating = false.obs;
  RxBool isTaskDateUpdating = false.obs;
  RxBool isMembersUpdating = false.obs;
  RxBool isDarkTheme = false.obs;
  RxBool isRecentProjectsListAtTop = true.obs;
  RxList<dynamic> comments = <dynamic>[].obs;
  RxList<dynamic> assets = <dynamic>[].obs;
  RxList<dynamic> users = <dynamic>[].obs;
  RxList<dynamic> projectMembers = <dynamic>[].obs;
  RxList<dynamic> toDoTasks = <dynamic>[].obs;
  RxList<dynamic> inProgressTasks = <dynamic>[].obs;
  RxList<dynamic> completedTasks = <dynamic>[].obs;
  RxList<dynamic> selectedDeliverables = <dynamic>[].obs;
  Rx<double> progress = 0.0.obs;
  Rx<int> commentsFilter = 1.obs;
  Rx<int> taskPrioritySelectedValue = 1.obs;
  Rx<int> taskSelectedValue = 1.obs;
  Rx<double> deliverableUplaodingProgress = 0.0.obs;
  Rx<String> phaseValue = "".obs;
  Rx<String> searchedNote = "".obs;
  Rx<String> taskPilot = "".obs;
  Rx<String> taskCoPilot = "".obs;
  Rx<String> projectPilot = "".obs;
  Rx<String> projectCoPilot = "".obs;
  final Rx<String> _uid = "".obs;
  final Rx<String> _projectId = "".obs;
  // ignore: prefer_typing_uninitialized_variables
  var app;

  updateUsers({
    String? uid,
  }) {
    _uid.value = uid!;
    getUsers();
    initialize();
  }

  updateProject({String? uid, String? projectId}) {
    _uid.value = uid!;
    _projectId.value = projectId!;
    getProjectData();
  }

  initialize() async {
    app = await firebase_dart.Firebase.initializeApp(
      options: const firebase_dart.FirebaseOptions(
          apiKey: "AIzaSyC9Jzj22llAEY9Zj1LjVMOxI8kVIFjP2VY",
          authDomain: "ava-project-ab57c.firebaseapp.com",
          projectId: "ava-project-ab57c",
          storageBucket: "ava-project-ab57c.appspot.com",
          messagingSenderId: "69104603518",
          appId: "1:69104603518:web:4ff45ea30c6e823b1fe32f"),
    );
  }

  getProjectAssets() async {
    assets.clear();
    if (!kIsWeb) {
      var projectAssets = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('assets')
          .orderBy('created', descending: true)
          .get();

      for (var asset in projectAssets) {
        assets.add(asset);
      }
    } else {
      QuerySnapshot projectAssets = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('assets')
          .orderBy('created', descending: true)
          .get();

      for (var asset in projectAssets.docs) {
        assets.add((asset.data() as dynamic));
      }
    }
  }

  getProjectMembers() async {
    projectMembers.clear();
    if (!kIsWeb) {
      await firedartFirestore
          .collection('users')
          .document(_uid.value)
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
          .doc(_uid.value)
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
        users.add(user);
      }
    } else {
      await firestore
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var user in querySnapshot.docs) {
          users.add((user.data() as dynamic));
        }
      });
    }
  }

  deleteProjectAsset({assetID}) async {
    FutureGroup futureGroup = FutureGroup();
    assets.removeWhere((element) => element['assetID'] == assetID);
    if (!kIsWeb) {
      for (var i = 0; i < projectMembers.length; i++) {
        futureGroup.add(firedartFirestore
            .collection('users')
            .document(projectMembers[i]['uid'])
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
      status == 'todo'
          ? toDoTasks.removeWhere((element) => element['taskID'] == taskID)
          : status == 'inProgress'
              ? inProgressTasks
                  .removeWhere((element) => element['taskID'] == taskID)
              : completedTasks
                  .removeWhere((element) => element['taskID'] == taskID);
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
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
      List? taskDeliverables,
      int? priorityLevel,
      int? deliverablesRequiredOrNot}) async {
    FutureGroup futureGroup = FutureGroup();
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskID: taskID,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: 'inProgress',
        requiredDeliverables: null,
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        deliverables: taskDeliverables,
        priorityLevel: priorityLevel);

    try {
      status == 'todo'
          ? toDoTasks.removeWhere((element) => element['taskID'] == taskID)
          : completedTasks
              .removeWhere((element) => element['taskID'] == taskID);

      inProgressTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': 'inProgress'}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': 'inProgress'}));
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
        status: 'todo',
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        deliverables: taskDeliverables,
        requiredDeliverables: null,
        priorityLevel: priorityLevel);
    try {
      status == 'inProgress'
          ? inProgressTasks
              .removeWhere((element) => element['taskID'] == taskID)
          : completedTasks
              .removeWhere((element) => element['taskID'] == taskID);

      toDoTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': 'todo'}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': 'todo'}));
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
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        deliverables: taskDeliverables,
        requiredDeliverables: requiredDeliverables,
        status: 'completed',
        isDeliverableNeededForCompletion: deliverablesRequiredOrNot,
        priorityLevel: priorityLevel);
    try {
      status == 'todo'
          ? toDoTasks.removeWhere((element) => element['taskID'] == taskID)
          : inProgressTasks
              .removeWhere((element) => element['taskID'] == taskID);

      completedTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .update({'status': 'completed'}));
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .doc(taskID)
              .update({'status': 'completed'}));
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
      var projectDataDoc = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .get();

      getProjectMembers();
      getProjectAssets();
      getProjectComments();
      getProjectTasks();

      // final projectData = projectDataDoc.data()! as dynamic;
      String title = projectDataDoc['title'];
      String subtitle = projectDataDoc['subtitle'];
      String lead = projectDataDoc['lead'];
      String copilot = projectDataDoc['copilot'];

      _project.value = {
        'title': title,
        'subtitle': subtitle,
        'lead': lead,
        'copilot': copilot,
      };
      update();
    } else {
      DocumentSnapshot projectDataDoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('projects')
          .doc(_projectId.value)
          .get();

      getProjectMembers();
      getProjectAssets();
      getProjectComments();
      getProjectTasks();

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
  }

  void newProject({
    String? title,
    String? subtitle,
    String? uid,
    String? username,
    String? pilot,
    String? copilot,
    String? catergory,
    List<ProjectMember>? initialProjectMembers,
  }) async {
    FutureGroup futureGroup = FutureGroup();
    String projectId = '';
    Project project = Project(
        copilot: copilot,
        lead: pilot,
        projectId: projectId,
        subtitle: subtitle,
        category: catergory,
        title: title);

    if (!kIsWeb) {
      try {
        await firedartFirestore
            .collection('users')
            .document('$uid')
            .collection('projects')
            .add(project.toJson())
            .then((value) async {
          projectId = value.id;
          await firedartFirestore
              .collection('users')
              .document('$uid')
              .collection('projects')
              .document(value.id)
              .update({'projectId': value.id}).then((value) async {
            for (var projectMember in initialProjectMembers!) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document('$uid')
                  .collection('projects')
                  .document(projectId)
                  .collection('members')
                  .document('${projectMember.uid}')
                  .set({
                "uid": projectMember.uid,
                'username': projectMember.username
              }));
            }
            futureGroup.close();

            Get.to(() => ProjectDashboard(projectId: projectId));
          });
        });

        getSuccessSnackBar("Project created successfully");
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
            .collection('projects')
            .add(project.toJson())
            .then((value) async {
          projectId = value.id;
          await firestore
              .collection('users')
              .doc(uid)
              .collection('projects')
              .doc(value.id)
              .update({'projectId': value.id}).then((value) async {
            for (var projectMember in initialProjectMembers!) {
              futureGroup.add(firestore
                  .collection('users')
                  .doc('$uid')
                  .collection('projects')
                  .doc(projectId)
                  .collection('members')
                  .doc('${projectMember.uid}')
                  .set({
                "uid": projectMember.uid,
                'username': projectMember.username
              }));
            }
            futureGroup.close();
            Get.to(() => ProjectDashboard(projectId: projectId));
          });
        });

        getSuccessSnackBar("Project created successfully");
      } catch (e) {
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  void addNewAsset({type, path, pathName}) async {
    FutureGroup futureGroup = FutureGroup();
    String assetID = '';

    if (!kIsWeb) {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(member['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .add({}).then((value) {
            assetID = value.id;
            firedartFirestore
                .collection('users')
                .document(member['uid'])
                .collection('projects')
                .document(_projectId.value)
                .collection('assets')
                .document(value.id)
                .set({
              "path": path,
              "pathName": pathName,
              "created": DateTime.now()
                  .millisecondsSinceEpoch
                  .toString()
                  .substring(0, 10),
              "assetID": value.id,
            });
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
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .add({}).then((value) {
            assetID = value.id;
            firestore
                .collection('users')
                .doc(member['uid'])
                .collection('projects')
                .doc(_projectId.value)
                .collection('assets')
                .doc(value.id)
                .set({
              "type": type,
              "path": path,
              "pathName": pathName,
              "created": DateTime.now()
                  .millisecondsSinceEpoch
                  .toString()
                  .substring(0, 10),
              "assetID": value.id,
            });
          }));
        }
        futureGroup.close();
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
    assets.insert(0, {"path": path, "pathName": pathName, "assetID": assetID});
  }

  void editAsset({path, pathName, assetID}) async {
    FutureGroup futureGroup = FutureGroup();

    for (int i = 0; i < assets.length; i++) {
      if (assets[i]['assetID'] == assetID) {
        int indexOfAsset = assets.indexOf(assets[i]);
        assets.removeAt(indexOfAsset);
      }
    }
    assets.insert(0, {"path": path, "pathName": pathName, "assetID": assetID});
    if (!kIsWeb) {
      try {
        for (var member in projectMembers) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(member['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .document(assetID)
              .update({
            "path": path,
            "pathName": pathName,
            "created": DateTime.now()
                .millisecondsSinceEpoch
                .toString()
                .substring(0, 10),
            "assetID": assetID
          }));
        }
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
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .doc(assetID)
              .update({
            "path": path,
            "pathName": pathName,
            "created": DateTime.now()
                .millisecondsSinceEpoch
                .toString()
                .substring(0, 10),
            "assetID": assetID
          }));
        }
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
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('comments')
          .orderBy(
            'created',
          )
          .get();

      for (var comment in projectComments) {
        comments.add(comment);
      }
    } else {
      QuerySnapshot projectComments = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('comments')
          .orderBy(
            'created',
          )
          .get();

      for (var comment in projectComments.docs) {
        comments.add((comment.data() as dynamic));
      }
    }
  }

  getProjectTasks() async {
    toDoTasks.clear();
    inProgressTasks.clear();
    completedTasks.clear();
    if (!kIsWeb) {
      var projectTasks = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('tasks')
          .get();

      for (var task in projectTasks) {
        if (task['status'] == 'todo') {
          toDoTasks.add(task);
        } else if (task['status'] == 'inProgress') {
          inProgressTasks.add(task);
        } else {
          completedTasks.add(task);
        }
      }
    } else {
      QuerySnapshot projectTasks = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('projects')
          .doc(_projectId.value)
          .collection('tasks')
          .get();

      for (var tasks in projectTasks.docs) {
        var task = tasks.data() as dynamic;

        if (task['status'] == 'todo') {
          toDoTasks.add(task);
        } else if (task['status'] == 'inProgress') {
          inProgressTasks.add(task);
        } else {
          completedTasks.add(task);
        }
      }
    }
  }

  addNewCommentFile({username, created}) async {
    FutureGroup futureGroup = FutureGroup();
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      Uint8List? file = result.files.first.bytes;
      String fileName = result.files.first.name;
      String? urlDownload;

      try {
        isCommentFileUpdatingBefore.value = true;
        var storage =
            firebase_dart_storage.FirebaseStorage.instanceFor(app: app);
        var ref = storage.ref().child("files/$fileName").putData(file!);

        ref.snapshotEvents.listen((event) {
          isCommentFileUpdatingBefore.value = false;
          progress.value = ((event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble()) *
              100);
          if (event.state == firebase_dart_storage.TaskState.success) {
            isCommentFileUpdatingAfter.value = true;

            event.ref.getDownloadURL().then((downloadUrl) async {
              urlDownload = downloadUrl;

              comments.add({
                "type": 'file',
                "comment": urlDownload,
                "username": username,
                "filename": event.ref.name,
                "created": created,
              });

              if (!kIsWeb) {
                for (var i = 0; i < projectMembers.length; i++) {
                  futureGroup.add(firedartFirestore
                      .collection('users')
                      .document(projectMembers[i]['uid'])
                      .collection('projects')
                      .document(_projectId.value)
                      .collection('comments')
                      .add({
                    "type": 'file',
                    "comment": urlDownload,
                    "username": username,
                    'filename': event.ref.name,
                    "created": created
                  }));
                }
              } else {
                for (var i = 0; i < projectMembers.length; i++) {
                  futureGroup.add(firestore
                      .collection('users')
                      .doc(projectMembers[i]['uid'])
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('comments')
                      .add({
                    "type": 'file',
                    "comment": urlDownload,
                    "username": username,
                    'filename': event.ref.name,
                    "created": created
                  }));
                }
              }
              isCommentFileUpdatingAfter.value = false;
            });
          }
        });
        futureGroup.close();
      } catch (e) {
        isCommentFileUpdatingBefore.value = false;
        isCommentFileUpdatingAfter.value = false;
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      // User canceled the picker
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
          var ref = storage.ref().child("files/$key").putData(value!);

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

  addNewComment({comment, username, created}) async {
    FutureGroup futureGroup = FutureGroup();
    comments.add({
      "type": 'text',
      "comment": comment,
      "created": created,
      "username": username
    });
    if (!kIsWeb) {
      try {
        for (var i = 0; i < projectMembers.length; i++) {
          futureGroup.add(firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('comments')
              .add({
            "type": 'text',
            "comment": comment,
            "username": username,
            "created": created
          }));
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
              .collection('projects')
              .doc(_projectId.value)
              .collection('comments')
              .add({
            "type": 'text',
            "comment": comment,
            "username": username,
            "created": created
          }));
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
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .add(task.toJson())
              .then((value) async {
            task_model.Task updatedTaskWithID = task_model.Task(
                taskTitle: taskTitle,
                phase: phase,
                taskID: value.id,
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
            if (projectMembers[i]['uid'] == _uid.value) {
              toDoTasks.add(updatedTaskWithID.toJson());
            }
            firedartFirestore
                .collection('users')
                .document(projectMembers[i]['uid'])
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
                startDate: startDate,
                requiredDeliverables: null,
                endDate: endDate,
                status: status,
                deliverables: deliverablesList,
                priorityLevel: priorityLevel);
            if (projectMembers[i]['uid'] == _uid.value) {
              toDoTasks.add(updatedTaskWithID.toJson());
            }

            firestore
                .collection('users')
                .doc(projectMembers[i]['uid'])
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
      getSuccessSnackBar("Task added successfully");
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
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: status,
        deliverables: taskDeliverables,
        priorityLevel: priorityLevel);

    if (status == 'todo') {
      toDoTasks.removeWhere((element) => element['taskID'] == taskID);
      toDoTasks.add(task.toJson());
    } else if (status == 'inProgress') {
      inProgressTasks.removeWhere((element) => element['taskID'] == taskID);
      inProgressTasks.add(task.toJson());
    } else {
      completedTasks.removeWhere((element) => element['taskID'] == taskID);
      completedTasks.add(task.toJson());
    }

    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          if (await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .document(taskID)
              .exists) {
            futureGroup.add(firedartFirestore
                .collection('users')
                .document(projectMembers[i]['uid'])
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

      getSuccessSnackBar("task updated successfully");
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
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('tasks')
                  .document(taskID)
                  .exists
              ? futureGroup.add(
                  firedartFirestore
                      .collection('users')
                      .document(projectMembers[i]['uid'])
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
    String? lead,
    String? copilot,
    String? title,
    String? subtitle,
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
              .collection('projects')
              .document(_projectId.value)
              .delete());

          futureGroup.add(firedartFirestore
              .collection('users')
              .document(removedMembers[i].uid!)
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
            .document(_uid.value)
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
                  .collection('projects')
                  .document(_projectId.value)
                  .update(
                {
                  'copilot': copilot,
                  'lead': lead,
                },
              ),
            );

            for (var projectMember in members) {
              if (exitedMembersList.contains(projectMember.uid)) {
              } else {
                futureGroup.add(firedartFirestore
                    .collection('users')
                    .document(members[i].uid!)
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
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('members')
                  .document(removedMember.uid!)
                  .delete());
            }
          } else {
            Project project = Project(
                copilot: copilot,
                lead: lead,
                projectId: _projectId.value,
                subtitle: subtitle,
                title: title);

            futureGroup.add(firedartFirestore
                .collection('users')
                .document(members[i].uid!)
                .collection('projects')
                .document(_projectId.value)
                .set(project.toJson()));

            for (var member in members) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
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
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('assets')
                  .add({
                "type": asset['type'],
                "path": asset['path'],
                "created": asset['created']
              }));
            }

            for (var comment in comments) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('comments')
                  .add({
                "type": comment['type'],
                "comment": comment['comment'],
                "username": comment['username'],
                "created": comment['created']
              }));
            }

            var tasksList = toDoTasks + inProgressTasks + completedTasks;

            for (var task in tasksList) {
              futureGroup.add(firedartFirestore
                  .collection('users')
                  .document(members[i].uid!)
                  .collection('projects')
                  .document(_projectId.value)
                  .collection('tasks')
                  .add({
                'taskTitle': task['taskTitle'],
                'phase': task['phase'],
                'taskDescription': task['taskDescription'],
                'pilot': task['pilot'],
                'copilot': task['copilot'],
                'startDate': task['startDate'],
                'endDate': task['endDate'],
                'status': task['status'],
                'priorityLevel': task['priorityLevel']
              }));
            }
          }
        }
        futureGroup.close();
        getProjectData();

        isMembersUpdating.value = false;

        getSuccessSnackBar("Members updated successfully");
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
              .collection('projects')
              .doc(_projectId.value)
              .delete());

          futureGroup.add(firestore
              .collection('users')
              .doc(removedMembers[i].uid)
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
              .collection('projects')
              .doc(_projectId.value)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              futureGroup.add(
                firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('projects')
                    .doc(_projectId.value)
                    .update(
                  {
                    'copilot': copilot,
                    'lead': lead,
                  },
                ),
              );

              for (var projectMember in members) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
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
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('members')
                    .doc(removedMember.uid)
                    .delete());
              }
            } else {
              Project project = Project(
                  copilot: copilot,
                  lead: lead,
                  projectId: _projectId.value,
                  subtitle: subtitle,
                  title: title);

              futureGroup.add(firestore
                  .collection('users')
                  .doc(members[i].uid)
                  .collection('projects')
                  .doc(_projectId.value)
                  .set(project.toJson()));

              for (var member in members) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
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
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('assets')
                    .add({
                  "type": asset['type'],
                  "path": asset['path'],
                  "created": asset['created']
                }));
              }

              for (var comment in comments) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('comments')
                    .add({
                  "type": comment['type'],
                  "comment": comment['comment'],
                  "username": comment['username'],
                  "created": comment['created']
                }));
              }

              var tasksList = toDoTasks + inProgressTasks + completedTasks;

              for (var task in tasksList) {
                futureGroup.add(firestore
                    .collection('users')
                    .doc(members[i].uid)
                    .collection('projects')
                    .doc(_projectId.value)
                    .collection('tasks')
                    .add({
                  'taskTitle': task['taskTitle'],
                  'phase': task['phase'],
                  'taskDescription': task['taskDescription'],
                  'pilot': task['pilot'],
                  'copilot': task['copilot'],
                  'startDate': task['startDate'],
                  'endDate': task['endDate'],
                  'status': task['status'],
                  'priorityLevel': task['priorityLevel']
                }));
              }
            }
          });
        }
        futureGroup.close();
        getProjectData();

        isMembersUpdating.value = false;

        getSuccessSnackBar("Members updated successfully");
      } catch (e) {
        isMembersUpdating.value = false;
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }
}
