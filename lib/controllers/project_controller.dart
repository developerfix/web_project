import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:projectx/models/project.dart';
import 'package:projectx/models/project_member.dart';
import 'package:projectx/models/task.dart' as task_model;
import 'package:projectx/pages/project_dashboard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/style.dart';

class ProjectController extends GetxController {
  final Rx<Map<String, dynamic>> _project = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get project => _project.value;

  RxBool isUploading = false.obs;
  RxBool isAssetUpdating = false.obs;
  RxBool isTasksUpdating = false.obs;
  RxBool isMembersUpdating = false.obs;
  RxList<dynamic> comments = <dynamic>[].obs;
  RxList<dynamic> assets = <dynamic>[].obs;
  RxList<dynamic> users = <dynamic>[].obs;
  RxList<dynamic> projectMembers = <dynamic>[].obs;
  RxList<dynamic> toDoTasks = <dynamic>[].obs;
  RxList<dynamic> inProgressTasks = <dynamic>[].obs;
  RxList<dynamic> completedTasks = <dynamic>[].obs;
  // Rx<double> progress = 0.0.obs;

  Rx<String> _uid = "".obs;
  Rx<String> _projectId = "".obs;

  updateProjectAndUserId({String? uid, String? projectId}) {
    _uid.value = uid!;
    _projectId.value = projectId!;
    getProjectData();
    getUsers();
    getProjectTasks();
  }

  getProjectAssets() async {
    if (!kIsWeb) {
      var projectAssets = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('assets')
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
          .get();

      for (var asset in projectAssets.docs) {
        assets.add((asset.data() as dynamic));
      }
    }
  }

  getProjectMembers() async {
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

  deleteProjectAsset({path}) async {
    assets.removeWhere((element) => element['path'] == path);
    if (!kIsWeb) {
      for (var i = 0; i < projectMembers.length; i++) {
        await firedartFirestore
            .collection('users')
            .document(projectMembers[i]['uid'])
            .collection('projects')
            .document(_projectId.value)
            .collection('assets')
            .where('path', isEqualTo: path)
            .get()
            .then((assets) {
          for (var doc in assets) {
            doc.reference.delete();
          }
        });
      }
    } else {
      for (var i = 0; i < projectMembers.length; i++) {
        await firestore
            .collection('users')
            .doc(projectMembers[i]['uid'])
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
      }
    }
  }

  deleteProjectTask({taskTitle, taskDescription, status}) async {
    try {
      status == 'todo'
          ? toDoTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle)
          : status == 'inProgress'
              ? inProgressTasks.removeWhere((element) =>
                  element['taskDescription'] == taskDescription &&
                  element['taskTitle'] == taskTitle)
              : completedTasks.removeWhere((element) =>
                  element['taskDescription'] == taskDescription &&
                  element['taskTitle'] == taskTitle);
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.delete();
            }
          });
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          });
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
      String? oldTaskTitle,
      String? phase,
      String? taskDescription,
      String? oldTaskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      int? priorityLevel}) async {
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: 'inProgress',
        priorityLevel: priorityLevel);

    try {
      status == 'todo'
          ? toDoTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle)
          : completedTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle);

      inProgressTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.update({'status': 'inProgress'});
            }
          });
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update({'status': 'inProgress'});
            }
          });
        }
      }
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addToTodo(
      {String? taskTitle,
      String? oldTaskTitle,
      String? phase,
      String? taskDescription,
      String? oldTaskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      int? priorityLevel}) async {
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: 'todo',
        priorityLevel: priorityLevel);
    try {
      status == 'inProgress'
          ? inProgressTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle)
          : completedTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle);

      toDoTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.update({'status': 'todo'});
            }
          });
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update({'status': 'todo'});
            }
          });
        }
      }
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  addToCompleted(
      {String? taskTitle,
      String? oldTaskTitle,
      String? phase,
      String? taskDescription,
      String? oldTaskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      int? priorityLevel}) async {
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: 'completed',
        priorityLevel: priorityLevel);
    try {
      status == 'todo'
          ? toDoTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle)
          : inProgressTasks.removeWhere((element) =>
              element['taskDescription'] == taskDescription &&
              element['taskTitle'] == taskTitle);

      completedTasks.add(task.toJson());
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.update({'status': 'completed'});
            }
          });
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: taskDescription)
              .where('taskTitle', isEqualTo: taskTitle)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update({'status': 'completed'});
            }
          });
        }
      }
    } catch (e) {
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
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

  void newProject(
      {String? title, String? subtitle, String? uid, String? username}) async {
    String projectId = '';
    Project project = Project(
        copilot: 'assign co-pilot',
        lead: 'assign lead',
        projectId: projectId,
        subtitle: subtitle,
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
            await firedartFirestore
                .collection('users')
                .document('$uid')
                .collection('projects')
                .document(projectId)
                .collection('members')
                .document('$uid')
                .set({"uid": uid, 'username': username}).then((value) {
              Get.to(ProjectDashboard(projectId: projectId));
            });
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
            await firestore
                .collection('users')
                .doc(uid)
                .collection('projects')
                .doc(projectId)
                .collection('members')
                .doc(uid)
                .set({"uid": uid, 'username': username}).then((value) {
              Get.to(ProjectDashboard(projectId: projectId));
            });
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

  void addNewAsset({type, path}) async {
    assets.add({"type": type, "path": path});
    if (!kIsWeb) {
      try {
        for (var member in projectMembers) {
          await firedartFirestore
              .collection('users')
              .document(member['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('assets')
              .add({"type": type, "path": path});
        }
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    } else {
      try {
        for (var member in projectMembers) {
          await firestore
              .collection('users')
              .doc(member['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('assets')
              .add({"type": type, "path": path});
        }
      } catch (e) {
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  getProjectComments() async {
    if (!kIsWeb) {
      var projectComments = await firedartFirestore
          .collection('users')
          .document(_uid.value)
          .collection('projects')
          .document(_projectId.value)
          .collection('comments')
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

  addNewCommentFile({username}) async {
    if (!kIsWeb) {
    } else {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          Uint8List? file = result.files.first.bytes;
          String fileName = result.files.first.name;

          UploadTask task = FirebaseStorage.instance
              .ref()
              .child("files/$fileName")
              .putData(file!);

          task.snapshotEvents.listen((event) {
            // setState(() {
            //   progress = ((event.bytesTransferred.toDouble() /
            //               event.totalBytes.toDouble()) *
            //           100)
            //       .roundToDouble();

            //   if (progress == 100) {
            //     event.ref
            //         .getDownloadURL()
            //         .then((downloadUrl) => print(downloadUrl));
            //   }

            //   print(progress);
            // });
          });
        }
        // FilePickerResult? result =
        //     await FilePicker.platform.pickFiles(allowMultiple: false);

        // UploadTask uploadTask;
        // String urlDownload;

        // if (result != null) {
        //   isUploading.value = true;
        //   // List<File> files = result.files.single.map((files) => File(path!)).toList();
        //   // List<File> filesNames =
        //   //     result.names.map((name) => File(name!)).toList();

        //   Uint8List? uploadfile = result.files.single.bytes;

        //   String filename = result.files.single.name;

        //   final ref =
        //       FirebaseStorage.instance.ref().child('commentFiles/$filename');
        //   uploadTask = ref.putData(uploadfile!);

        //   uploadTask.snapshotEvents.listen((event) {
        //     // ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
        //     //     100) as Rx<double>;

        //     // if (progress == 100) {
        //     //   event.ref.getDownloadURL().then((downloadUrl) {
        //     //     urlDownload = downloadUrl;
        //     //   });
        //     //   isUploading.value = false;
        //     // }
        //   });

        // final snapshot = await uploadTask.whenComplete(() {});
        // final urlDownload = await snapshot.ref.getDownloadURL();
        // for (var i = 0; i < projectMembers.length; i++) {
        //   await firestore
        //       .collection('users')
        //       .doc(projectMembers[i]['uid'])
        //       .collection('projects')
        //       .doc(_projectId.value)
        //       .collection('comments')
        //       .add({
        //     "type": 'file',
        //     "comment": urlDownload,
        //     "username": username
        //   });
        // }
        // isUploading.value = false;

        // comments.add(
        //     {"type": 'file', "comment": urlDownload, "username": username});
        // }
        //  else {
        //   // User canceled the picker
        // }
      } catch (e) {
        isUploading.value = false;
        //define error
        getErrorSnackBar(
          "Something went wrong, Please try again",
        );
      }
    }
  }

  addNewComment({comment, username}) async {
    comments.add({"type": 'text', "comment": comment, "username": username});
    if (!kIsWeb) {
      for (var i = 0; i < projectMembers.length; i++) {
        await firedartFirestore
            .collection('users')
            .document(projectMembers[i]['uid'])
            .collection('projects')
            .document(_projectId.value)
            .collection('comments')
            .add({"type": 'text', "comment": comment, "username": username});
      }
    } else {
      try {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('comments')
              .add({"type": 'text', "comment": comment, "username": username});
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
      String? oldTaskTitle,
      String? phase,
      String? taskDescription,
      String? oldTaskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      int? priorityLevel}) async {
    isTasksUpdating.value = true;
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: status,
        priorityLevel: priorityLevel);
    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .add(task.toJson());
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .add(task.toJson());
        }
      }
      getProjectTasks();
      isTasksUpdating.value = false;
      getSuccessSnackBar("task added successfully");
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar(
        "Something went wrong, Please try again",
      );
    }
  }

  updateTask(
      {String? taskTitle,
      String? oldTaskTitle,
      String? phase,
      String? taskDescription,
      String? oldTaskDescription,
      String? pilot,
      String? copilot,
      String? startDate,
      String? endDate,
      String? status,
      int? priorityLevel}) async {
    isTasksUpdating.value = true;
    task_model.Task task = task_model.Task(
        taskTitle: taskTitle,
        phase: phase,
        taskDescription: taskDescription,
        pilot: pilot,
        copilot: copilot,
        startDate: startDate,
        endDate: endDate,
        status: status,
        priorityLevel: priorityLevel);
    try {
      if (!kIsWeb) {
        for (var i = 0; i < projectMembers.length; i++) {
          await firedartFirestore
              .collection('users')
              .document(projectMembers[i]['uid'])
              .collection('projects')
              .document(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: oldTaskDescription)
              .where('taskTitle', isEqualTo: oldTaskTitle)
              .get()
              .then((value) {
            for (var doc in value) {
              doc.reference.update(task.toJson());
            }
          });
        }
      } else {
        for (var i = 0; i < projectMembers.length; i++) {
          await firestore
              .collection('users')
              .doc(projectMembers[i]['uid'])
              .collection('projects')
              .doc(_projectId.value)
              .collection('tasks')
              .where('taskDescription', isEqualTo: oldTaskDescription)
              .where('taskTitle', isEqualTo: oldTaskTitle)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update(task.toJson());
            }
          });
        }
      }
      getProjectTasks();

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

  manageProjectMembers({
    String? lead,
    String? copilot,
    String? title,
    String? subtitle,
    List<ProjectMember>? members,
    List<ProjectMember>? removedMembers,
  }) async {
    if (!kIsWeb) {
      // isMembersUpdating.value = true;
      // projectMembers.clear();
      // for (var i = 0; i < removedMembers!.length; i++) {
      //   await firedartFirestore
      //       .collection('users')
      //       .document('${removedMembers[i].uid}')
      //       .collection('projects')
      //       .document(_projectId.value)
      //       .delete();
      // }

      // try {
      //   for (var i = 0; i < members!.length; i++) {
      //     await firedartFirestore
      //         .collection('users')
      //         .document('${members[i].uid}')
      //         .collection('projects')
      //         .document(_projectId.value)
      //         .get()
      //         .then((document) async {
      //       if (document.) {
      //         await firedartFirestore
      //             .collection('users')
      //             .document(members[i].uid)
      //             .collection('projects')
      //             .document(_projectId.value)
      //             .update({
      //           'copilot': copilot,
      //           'lead': lead,
      //         }).then((value) async {
      //           for (var projectMember in members) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('members')
      //                 .document(projectMember.uid)
      //                 .get()
      //                 .then((DocumentSnapshot document) async {
      //               if (document.exists) {
      //               } else {
      //                 await firedartFirestore
      //                     .collection('users')
      //                     .document(members[i].uid)
      //                     .collection('projects')
      //                     .document(_projectId.value)
      //                     .collection('members')
      //                     .document(projectMember.uid)
      //                     .set({
      //                   'uid': projectMember.uid,
      //                   'username': projectMember.username
      //                 });
      //               }
      //             });
      //           }
      //         }).then((value) async {
      //           for (var asset in assets) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('assets')
      //                 .add({"type": asset['type'], "path": asset['path']});
      //           }
      //         }).then((value) async {
      //           for (var comment in comments) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('comments')
      //                 .add({
      //               "type": comment['type'],
      //               "comment": comment['comment'],
      //               "username": comment['username']
      //             });
      //           }
      //         }).then((value) async {
      //           var tasksList = toDoTasks + inProgressTasks + completedTasks;
      //           for (var task in tasksList) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('tasks')
      //                 .add({
      //               'taskTitle': task['taskTitle'],
      //               'phase': task['phase'],
      //               'taskDescription': task['taskDescription'],
      //               'pilot': task['pilot'],
      //               'copilot': task['copilot'],
      //               'startDate': task['startDate'],
      //               'endDate': task['endDate'],
      //               'status': task['status'],
      //               'priorityLevel': task['priorityLevel']
      //             });
      //           }
      //         }).then((value) async {
      //           for (var removedMember in removedMembers) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('members')
      //                 .document(removedMember.uid)
      //                 .delete();
      //           }
      //         });
      //       } else {
      //         Project project = Project(
      //             copilot: copilot,
      //             lead: lead,
      //             projectId: _projectId.value,
      //             subtitle: subtitle,
      //             title: title);

      //         await firedartFirestore
      //             .collection('users')
      //             .document(members[i].uid)
      //             .collection('projects')
      //             .document(_projectId.value)
      //             .set(project.toJson())
      //             .then((value) async {
      //           for (var member in members) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('members')
      //                 .document(
      //                   member.uid,
      //                 )
      //                 .set({'uid': member.uid, 'username': member.username});
      //           }
      //         }).then((value) async {
      //           for (var asset in assets) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('assets')
      //                 .add({"type": asset['type'], "path": asset['path']});
      //           }
      //         }).then((value) async {
      //           for (var comment in comments) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('comments')
      //                 .add({
      //               "type": comment['type'],
      //               "comment": comment['comment'],
      //               "username": comment['username']
      //             });
      //           }
      //         }).then((value) async {
      //           var tasksList = toDoTasks + inProgressTasks + completedTasks;
      //           for (var task in tasksList) {
      //             await firedartFirestore
      //                 .collection('users')
      //                 .document(members[i].uid)
      //                 .collection('projects')
      //                 .document(_projectId.value)
      //                 .collection('tasks')
      //                 .add({
      //               'taskTitle': task['taskTitle'],
      //               'phase': task['phase'],
      //               'taskDescription': task['taskDescription'],
      //               'pilot': task['pilot'],
      //               'copilot': task['copilot'],
      //               'startDate': task['startDate'],
      //               'endDate': task['endDate'],
      //               'status': task['status'],
      //               'priorityLevel': task['priorityLevel']
      //             });
      //           }
      //         });
      //       }
      //     });
      //   }

      //   getProjectData();

      //   isMembersUpdating.value = false;

      //   getSuccessSnackBar("Members updated successfully");
      // } catch (e) {
      //   isMembersUpdating.value = false;
      //   getErrorSnackBar(
      //     "Something went wrong, Please try again",
      //   );
      // }
    } else {
      isMembersUpdating.value = true;
      projectMembers.clear();
      for (var i = 0; i < removedMembers!.length; i++) {
        await firestore
            .collection('users')
            .doc(removedMembers[i].uid)
            .collection('projects')
            .doc(_projectId.value)
            .delete();
      }

      try {
        for (var i = 0; i < members!.length; i++) {
          await firestore
              .collection('users')
              .doc(members[i].uid)
              .collection('projects')
              .doc(_projectId.value)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              await firestore
                  .collection('users')
                  .doc(members[i].uid)
                  .collection('projects')
                  .doc(_projectId.value)
                  .update({
                'copilot': copilot,
                'lead': lead,
              }).then((value) async {
                for (var projectMember in members) {
                  await firestore
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
                  });
                }
              }).then((value) async {
                for (var asset in assets) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('assets')
                      .add({"type": asset['type'], "path": asset['path']});
                }
              }).then((value) async {
                for (var comment in comments) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('comments')
                      .add({
                    "type": comment['type'],
                    "comment": comment['comment'],
                    "username": comment['username']
                  });
                }
              }).then((value) async {
                var tasksList = toDoTasks + inProgressTasks + completedTasks;
                for (var task in tasksList) {
                  await firestore
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
                  });
                }
              }).then((value) async {
                for (var removedMember in removedMembers) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('members')
                      .doc(removedMember.uid)
                      .delete();
                }
              });
            } else {
              Project project = Project(
                  copilot: copilot,
                  lead: lead,
                  projectId: _projectId.value,
                  subtitle: subtitle,
                  title: title);

              await firestore
                  .collection('users')
                  .doc(members[i].uid)
                  .collection('projects')
                  .doc(_projectId.value)
                  .set(project.toJson())
                  .then((value) async {
                for (var member in members) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('members')
                      .doc(
                        member.uid,
                      )
                      .set({'uid': member.uid, 'username': member.username});
                }
              }).then((value) async {
                for (var asset in assets) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('assets')
                      .add({"type": asset['type'], "path": asset['path']});
                }
              }).then((value) async {
                for (var comment in comments) {
                  await firestore
                      .collection('users')
                      .doc(members[i].uid)
                      .collection('projects')
                      .doc(_projectId.value)
                      .collection('comments')
                      .add({
                    "type": comment['type'],
                    "comment": comment['comment'],
                    "username": comment['username']
                  });
                }
              }).then((value) async {
                var tasksList = toDoTasks + inProgressTasks + completedTasks;
                for (var task in tasksList) {
                  await firestore
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
                  });
                }
              });
            }
          });
        }

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
