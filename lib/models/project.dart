import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String? projectId;
  String? title;
  String? subtitle;
  String? lead;
  String? copilot;

  Project({
    this.projectId,
    this.title,
    this.subtitle,
    this.lead,
    this.copilot,
  });

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "title": title,
        "subtitle": subtitle,
        "lead": lead,
        "copilot": copilot
      };

  static Project fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        lead: snapshot['lead']);
  }
}
