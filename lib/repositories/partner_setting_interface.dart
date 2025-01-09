import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twine/models/partner_settings_model.dart';

abstract class IPartnerSettingRepository {
  Future<PartnerSettings?> get(String uid);
  Future<void> update(String uid, Map<String, dynamic> data);
}

class PartnerSettingRepository implements IPartnerSettingRepository {
  late CollectionReference<Map<String, dynamic>> partnerTable;

  PartnerSettingRepository(db) {
    partnerTable = db.collection("partnerSettings");
  }

  @override
  Future<PartnerSettings?> get(String uid) async {
    try {
      final snap = await partnerTable.where("userId", isEqualTo: uid).withConverter(
        fromFirestore: PartnerSettings.fromFirestore, 
        toFirestore: (PartnerSettings partnerSettings, _) => partnerSettings.toFirestore()
      ).get();
      if (snap.size == 1) {
        return snap.docs[0].data();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> update(String uid, Map<String, dynamic> data) async {
    final snap = await partnerTable.where("userId", isEqualTo: uid).get();
    if (snap.size == 1) {
      await partnerTable.doc(snap.docs[0].id).update(data);
    }
  }
}