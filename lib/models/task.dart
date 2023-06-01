import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Task {
  String? taskTitle;
  String? phase;
  String? taskDescription;
  String? pilot;
  String? copilot;
  String? startDate;
  String? endDate;
  int? priorityLevel;
  String? daysToComplete;
  String? taskID;
  String? status;
  int? isDeliverableNeededForCompletion;
  List? deliverables;
  List? requiredDeliverables;

  Task(
      {this.taskTitle,
      this.phase,
      this.deliverables,
      this.taskDescription,
      this.pilot,
      this.copilot,
      this.daysToComplete,
      this.startDate,
      this.taskID,
      this.endDate,
      this.status,
      this.requiredDeliverables,
      this.isDeliverableNeededForCompletion,
      this.priorityLevel});

  Map<String, dynamic> toJson() => {
        "taskTitle": taskTitle,
        "phase": phase,
        "isDeliverableNeededForCompletion": isDeliverableNeededForCompletion,
        "taskDescription": taskDescription,
        "taskID": taskID,
        "daysToComplete": daysToComplete,
        "deliverables": deliverables,
        "requiredDeliverables": requiredDeliverables,
        "pilot": pilot,
        "copilot": copilot,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "priorityLevel": priorityLevel
      };

  static Task fromDocumentSnap(Document snap) {
    var snapshot = snap;
    return Task(
      taskTitle: snapshot['taskTitle'],
      phase: snapshot['phase'],
      taskID: snapshot['taskID'],
      isDeliverableNeededForCompletion:
          snapshot['isDeliverableNeededForCompletion'],
      taskDescription: snapshot['taskDescription'],
      deliverables: snapshot['deliverables'],
      requiredDeliverables: snapshot['requiredDeliverables'],
      pilot: snapshot['pilot'],
      daysToComplete: snapshot['daysToComplete'],
      copilot: snapshot['copilot'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      status: snapshot['status'],
      priorityLevel: snapshot['priorityLevel'],
    );
  }

  static Task fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Task(
      taskTitle: snapshot['taskTitle'],
      phase: snapshot['phase'],
      taskID: snapshot['taskID'],
      isDeliverableNeededForCompletion:
          snapshot['isDeliverableNeededForCompletion'],
      taskDescription: snapshot['taskDescription'],
      deliverables: snapshot['deliverables'],
      requiredDeliverables: snapshot['requiredDeliverables'],
      pilot: snapshot['pilot'],
      daysToComplete: snapshot['daysToComplete'],
      copilot: snapshot['copilot'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      status: snapshot['status'],
      priorityLevel: snapshot['priorityLevel'],
    );
  }
}
