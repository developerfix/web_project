import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class User {
  String? name;
  String? profilePhoto;
  String? email;
  String? uid;
  String? lastOpenedProjectId;
  String? lastOpenedDocumentId;

  User({
    this.name,
    this.email,
    this.uid,
    this.profilePhoto,
    this.lastOpenedProjectId,
    this.lastOpenedDocumentId,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "lastOpenedProjectId": lastOpenedProjectId,
        "lastOpenedDocumentId": lastOpenedDocumentId,
      };

  static User fromDocumentSnapshot(DocumentSnapshot snap) {
    var snapshot = snap;
    return User(
      email: snapshot['email'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      lastOpenedProjectId: snapshot['lastOpenedProjectId'],
      lastOpenedDocumentId: snapshot['lastOpenedDocumentId'],
    );
  }

  static User fromDoc(Document snap) {
    var snapshot = snap.map;
    return User(
      email: snapshot['email'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      lastOpenedProjectId: snapshot['lastOpenedProjectId'],
      lastOpenedDocumentId: snapshot['lastOpenedDocumentId'],
    );
  }

  static User fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return User(
      email: snapshot['email'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      lastOpenedProjectId: snapshot['lastOpenedProjectId'],
      lastOpenedDocumentId: snapshot['lastOpenedDocumentId'],
    );
  }
}
