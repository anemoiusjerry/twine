import 'package:cloud_firestore/cloud_firestore.dart';

class TwineUser {
  final String? coupleId;
  final String? email;
  final String? name;
  final String? connectCode;
  final Timestamp? birthday;
  final Timestamp? creationDate;
  final Timestamp? lastActivity;

  TwineUser({
    this.coupleId,
    this.email,
    this.name,
    this.connectCode,
    this.birthday,
    this.creationDate,
    this.lastActivity,
  });

  factory TwineUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TwineUser(
      coupleId: data?['coupleId'],
      email: data?['email'],
      name: data?['name'],
      connectCode: data?['connectCode'],
      birthday: data?['birthday'],
      creationDate: data?['creationDate'],
      lastActivity: data?['lastActivity'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (coupleId != null) 'coupleId': coupleId,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (connectCode != null) 'connectCode': connectCode,
      if (birthday != null) 'birthday': birthday,
      if (creationDate != null) 'creationDate': creationDate,
      if (lastActivity != null) 'lastActivity': lastActivity, 
    };
  }
}