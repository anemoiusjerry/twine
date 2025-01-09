import 'package:cloud_firestore/cloud_firestore.dart';

class AudioLog {
  final Timestamp? creationDate;
  final String? name;
  final bool? favourite;
  final String? recordedBy;

  AudioLog({
    this.creationDate,
    this.name,
    this.favourite,
    this.recordedBy,
  });

  factory AudioLog.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AudioLog(
      creationDate: data?['creationDate'],
      name: data?['name'],
      favourite: data?['favourite'],
      recordedBy: data?['recordedBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (creationDate != null) 'creationDate': creationDate,
      if (name != null) 'name': name,
      if (favourite != null) 'favourite': favourite,
      if (recordedBy != null) 'recordedBy': recordedBy,
    };
  }
}