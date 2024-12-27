import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twine/models/couple_model.dart';

abstract class ICoupleRepository {
  Future<Couple?> get(String id);
  Future<void> edit(String id, Map<String, dynamic> data);
}

class CoupleRepository implements ICoupleRepository {
  final FirebaseFirestore db;
  late CollectionReference<Map<String, dynamic>> couplesTable;

  CoupleRepository(this.db) {
    couplesTable = db.collection("couples");
  }

  @override
  Future<Couple?> get(String id) async {
    final ref = couplesTable.doc(id).withConverter(
      fromFirestore: Couple.fromFirestore, 
      toFirestore: (Couple couple, _) => couple.toFirestore(),
    );
    final snapshot = await ref.get();
    return snapshot.data();
  }

  @override
  Future<void> edit(String id, Map<String, dynamic> data) async {
    final ref = couplesTable.doc(id);
    await ref.update(data);
  }
}