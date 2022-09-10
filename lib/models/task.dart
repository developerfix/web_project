import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? taskTitle;
  String? phase;
  String? taskDescription;
  String? pilot;
  String? copilot;
  String? startDate;
  String? endDate;
  int? priorityLevel;
  String? status;
  int? isDeliverableNeededForCompletion;
  List? deliverables;

  Task(
      {this.taskTitle,
      this.phase,
      this.deliverables,
      this.taskDescription,
      this.pilot,
      this.copilot,
      this.startDate,
      this.endDate,
      this.status,
      this.isDeliverableNeededForCompletion,
      this.priorityLevel});

  Map<String, dynamic> toJson() => {
        "taskTitle": taskTitle,
        "phase": phase,
        "isDeliverableNeededForCompletion": isDeliverableNeededForCompletion,
        "taskDescription": taskDescription,
        "deliverables": deliverables,
        "pilot": pilot,
        "copilot": copilot,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "priorityLevel": priorityLevel
      };

  static Task fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Task(
      taskTitle: snapshot['taskTitle'],
      phase: snapshot['phase'],
      isDeliverableNeededForCompletion:
          snapshot['isDeliverableNeededForCompletion'],
      taskDescription: snapshot['taskDescription'],
      deliverables: snapshot['deliverables'],
      pilot: snapshot['pilot'],
      copilot: snapshot['copilot'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      status: snapshot['status'],
      priorityLevel: snapshot['priorityLevel'],
    );
  }
}
