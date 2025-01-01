import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerSettings {
  final String? userId;
  final String? nickName;
  final String? timezone;

  PartnerSettings({
    this.userId,
    this.nickName,
    this.timezone,
  });

  factory PartnerSettings.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PartnerSettings(
      userId: data?['userId'],
      nickName: data?['nickName'],
      timezone: data?['timezone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) 'userId': userId,
      if (nickName != null) 'nickName': nickName,
      if (timezone != null) 'timezone': timezone,
    };
  }
}