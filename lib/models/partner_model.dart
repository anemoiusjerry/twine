import 'package:cloud_firestore/cloud_firestore.dart';

class Partner {
  final String? partnerUserId;
  final String? imageUrl;
  final String? nickName;
  final String? timezone;

  Partner({
    this.partnerUserId,
    this.imageUrl,
    this.nickName,
    this.timezone,
  });

  factory Partner.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, 
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Partner(
      partnerUserId: data?['partnerUserId'],
      imageUrl: data?['imageUrl'],
      nickName: data?['nickName'],
      timezone: data?['timezone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (partnerUserId != null) 'partnerUserId': partnerUserId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (nickName != null) 'nickName': nickName,
      if (timezone != null) 'timezone': timezone,
    };
  }
}