import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? name;
  String? profilePhoto;
  String? email;
  String? uid;
  int? noOfProjects;

  User({this.name, this.email, this.uid, this.profilePhoto, this.noOfProjects});

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "noOfProjects": noOfProjects
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot['email'],
        profilePhoto: snapshot['profilePhoto'],
        uid: snapshot['uid'],
        name: snapshot['name'],
        noOfProjects: snapshot['noOfProjects']);
  }
}
