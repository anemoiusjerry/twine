import 'package:cloud_firestore/cloud_firestore.dart';

class Couple {
  final List<String>? users;
  final String? connectCode;
  final Timestamp? creationDate;
  final Timestamp? anniversaryDate;
  final Timestamp? reunionDate;

  Couple({
    this.users,
    this.connectCode,
    this.creationDate,
    this.anniversaryDate,
    this.reunionDate,
  });

  factory Couple.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Couple(
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      connectCode: data?['connectCode'],
      creationDate: data?['creationDate'],
      anniversaryDate: data?['anniversaryDate'],
      reunionDate: data?['reunionDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (users != null) 'users': users,
      if (connectCode != null) 'connectCode': connectCode,
      if (creationDate != null) 'creationDate': creationDate,
      if (anniversaryDate != null) 'anniversaryDate': anniversaryDate,
      if (reunionDate != null) 'reunionDate': reunionDate,
    };
  }
}