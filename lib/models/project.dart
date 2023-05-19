import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Project {
  String? projectId;
  String? title;
  String? subtitle;
  String? lead;
  String? leadID;
  String? copilot;
  String? copilotID;
  String? category;
  DateTime? lastOpened;

  Project(
      {this.projectId,
      this.title,
      this.lastOpened,
      this.subtitle,
      this.lead,
      this.leadID,
      this.copilotID,
      this.copilot,
      this.category});

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "title": title,
        "lastOpened": lastOpened,
        "subtitle": subtitle,
        "lead": lead,
        "leadID": leadID,
        "copilotID": copilotID,
        "copilot": copilot,
        "category": category
      };

  static Project fromSnap(Document snap) {
    var snapshot = snap.map;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        lastOpened: snapshot['lastOpened'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        category: snapshot['category'],
        copilotID: snapshot['copilotID'],
        leadID: snapshot['leadID'],
        lead: snapshot['lead']);
  }

  static Project fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        lastOpened: snapshot['lastOpened'].toDate(),
        subtitle: snapshot['subtitle'],
        leadID: snapshot['leadID'],
        copilot: snapshot['copilot'],
        copilotID: snapshot['copilotID'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }

  static Project fromDocSnap(DocumentSnapshot snap) {
    var snapshot = snap;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        lastOpened: snapshot['lastOpened'].toDate(),
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        leadID: snapshot['leadID'],
        copilotID: snapshot['copilotID'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }
}
