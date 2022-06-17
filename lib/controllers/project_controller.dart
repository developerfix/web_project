import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:projectx/models/project.dart';
import 'package:projectx/models/task.dart' as taskModel;

import '../constants/style.dart';

class ProjectController extends GetxController {
  final Rx<Map<String, dynamic>> _project = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get project => _project.value;

  RxBool isUploading = false.obs;
  RxBool isAssetUpdating = false.obs;
  RxBool isTasksUpdating = false.obs;
  RxList<dynamic> comments = <dynamic>[].obs;
  RxList<dynamic> assets = <dynamic>[].obs;
  RxList<dynamic> users = <dynamic>[].obs;
  RxList<dynamic> toDoTasks = <dynamic>[].obs;
  RxList<dynamic> inProgressTasks = <dynamic>[].obs;
  RxList<dynamic> completedTasks = <dynamic>[].obs;

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
    users.clear();
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
      assets.removeWhere((element) => element['path'] == path);

      isAssetUpdating.value = false;
    });
  }

  deleteProjectTask({taskTitle, taskDescription, status}) async {
    isTasksUpdating.value = true;
    try {
      await firestore
          .collection('users')
          .doc(_uid.value)
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

        isTasksUpdating.value = false;
      });
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  addToInProgress(
      {uid,
      projectId,
      taskTitle,
      phase,
      taskDescription,
      pilot,
      copilot,
      startDate,
      endDate,
      status,
      priorityLevel}) async {
    isTasksUpdating.value = true;
    taskModel.Task task = taskModel.Task(
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
      await firestore
          .collection('users')
          .doc(_uid.value)
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

        status == 'todo'
            ? toDoTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle)
            : completedTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle);

        inProgressTasks.add(task.toJson());
        isTasksUpdating.value = false;
      });
      getSuccessSnackBar("Task updated successfully");
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  addToTodo(
      {uid,
      projectId,
      taskTitle,
      phase,
      taskDescription,
      pilot,
      copilot,
      startDate,
      endDate,
      status,
      priorityLevel}) async {
    isTasksUpdating.value = true;
    taskModel.Task task = taskModel.Task(
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
      await firestore
          .collection('users')
          .doc(_uid.value)
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

        status == 'inProgress'
            ? inProgressTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle)
            : completedTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle);

        toDoTasks.add(task.toJson());
        isTasksUpdating.value = false;
      });
      getSuccessSnackBar("Task updated successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  addToCompleted(
      {uid,
      projectId,
      taskTitle,
      phase,
      taskDescription,
      pilot,
      copilot,
      startDate,
      endDate,
      status,
      priorityLevel}) async {
    isTasksUpdating.value = true;
    taskModel.Task task = taskModel.Task(
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
      await firestore
          .collection('users')
          .doc(_uid.value)
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

        status == 'todo'
            ? toDoTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle)
            : inProgressTasks.removeWhere((element) =>
                element['taskDescription'] == taskDescription &&
                element['taskTitle'] == taskTitle);

        completedTasks.add(task.toJson());
        isTasksUpdating.value = false;
      });
      getSuccessSnackBar("Task updated successfully");
    } catch (e) {
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
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
          .add({"type": type, "path": path}).then((value) {
        assets.add({"type": type, "path": path});
        isAssetUpdating.value = false;
      });

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

  getProjectTasks() async {
    toDoTasks.clear();
    inProgressTasks.clear();
    completedTasks.clear();
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

  addNewTask(
      {uid,
      projectId,
      taskTitle,
      phase,
      taskDescription,
      pilot,
      copilot,
      startDate,
      endDate,
      status,
      priorityLevel}) async {
    isTasksUpdating.value = true;
    taskModel.Task task = taskModel.Task(
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
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .add(task.toJson())
          .then((value) {
        // toDoTasks.add(task.toJson());
        getProjectTasks();
        isTasksUpdating.value = false;
      });

      getSuccessSnackBar("task added successfully");
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }

  updateTask(
      {uid,
      projectId,
      taskTitle,
      oldTaskTitle,
      phase,
      taskDescription,
      oldTaskDescription,
      pilot,
      copilot,
      startDate,
      endDate,
      status,
      priorityLevel}) async {
    isTasksUpdating.value = true;
    taskModel.Task task = taskModel.Task(
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
      await firestore
          .collection('users')
          .doc(uid)
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .where('taskDescription', isEqualTo: oldTaskDescription)
          .where('taskTitle', isEqualTo: oldTaskTitle)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update(task.toJson());
        }
        getProjectTasks();

        isTasksUpdating.value = false;
      });

      getSuccessSnackBar("task updated successfully");
    } catch (e) {
      isTasksUpdating.value = false;
      //define error
      getErrorSnackBar("Something went wrong, Please try again", '');
    }
  }
}
