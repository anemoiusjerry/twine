import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twine/models/user_model.dart';

abstract class IUserRepository {
  Future<TwineUser?> get(String id);
  Future<void> update(String id, Map<String, dynamic> data);
}

class UserRepository implements IUserRepository {
  late CollectionReference<Map<String, dynamic>> usersTable;

  UserRepository(db) {
    usersTable = db.collection('users');
  }

  @override
  Future<TwineUser?> get(String uid) async {
    final ref = usersTable.doc(uid).withConverter(
      fromFirestore: TwineUser.fromFirestore, 
      toFirestore: (TwineUser user, _) => user.toFirestore()
    );
    final docSnap = await ref.get();
    // multi-accounts all link to same email thus there's always 1 doc
    return docSnap.data();
  }

  @override
  Future<void> update(String id, Map<String, dynamic> data) async {
    final ref = usersTable.doc(id);
    await ref.update(data);
  }
}