import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Department {
  String? departmentId;
  String? title;
  int? iconCode;
  DateTime? createdAt;

  Department({
    this.departmentId,
    this.title,
    this.iconCode,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "departmentId": departmentId,
        "title": title,
        "iconCode": iconCode,
        "createdAt": createdAt,
      };

  static Department fromSnap(Document snap) {
    var snapshot = snap.map;
    return Department(
      departmentId: snapshot['departmentId'],
      createdAt: snapshot['createdAt'],
      title: snapshot['title'],
      iconCode: snapshot['iconCode'],
    );
  }

  static Department fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Department(
      departmentId: snapshot['departmentId'],
      title: snapshot['title'],
      createdAt: snapshot['createdAt'].toDate(),
      iconCode: snapshot['iconCode'],
    );
  }

  static Department fromDocSnap(DocumentSnapshot snap) {
    var snapshot = snap;
    return Department(
      departmentId: snapshot['departmentId'],
      title: snapshot['title'],
      createdAt: snapshot['createdAt'].toDate(),
      iconCode: snapshot['iconCode'],
    );
  }
}
