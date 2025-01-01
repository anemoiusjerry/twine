import 'package:cloud_firestore/cloud_firestore.dart';

class Couple {
  final List<String>? users;
  final Timestamp? creationDate;
  final Timestamp? anniversaryDate;
  final Timestamp? reunionDate;
  final Timestamp? separationDate;

  Couple({
    this.users,
    this.creationDate,
    this.anniversaryDate,
    this.reunionDate,
    this.separationDate,
  });

  factory Couple.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Couple(
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      creationDate: data?['creationDate'],
      anniversaryDate: data?['anniversaryDate'],
      reunionDate: data?['reunionDate'],
      separationDate: data?['separationDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (users != null) 'users': users,
      if (creationDate != null) 'creationDate': creationDate,
      if (anniversaryDate != null) 'anniversaryDate': anniversaryDate,
      if (reunionDate != null) 'reunionDate': reunionDate,
      if (separationDate != null) 'separationDate': separationDate,
    };
  }
}