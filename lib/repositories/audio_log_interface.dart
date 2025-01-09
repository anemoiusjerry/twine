import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twine/models/audio_log_model.dart';

abstract class IAudioLogRepository {
  Future<AudioLog?> get(String id);
  Future<String?> create(AudioLog metadata);
  Future<void> edit(String id, Map<String, dynamic> data);
  Future<void> delete(String id,);
}

class AudioLogRepository implements IAudioLogRepository {
  late CollectionReference<Map<String, dynamic>> audioLogsTable;

  AudioLogRepository(db) {
    audioLogsTable = db.collection("audioLogs");
  }

  @override
  Future<AudioLog?> get(String id) async {
    try {
      final ref = audioLogsTable.doc(id).withConverter(
        fromFirestore: AudioLog.fromFirestore, 
        toFirestore: (AudioLog audioLog, _) => audioLog.toFirestore(),
      );
      final snapshot = await ref.get();
      return snapshot.data();
    } catch(e) {
      print(e);
      return null;
    }
  }

  @override
  Future<String> create(AudioLog metadata) async {
    final docRef = await audioLogsTable.add(metadata.toFirestore());
    return docRef.id;
  }

  @override
  Future<void> edit(String id, Map<String, dynamic> data) async {
    final ref = audioLogsTable.doc(id);
    await ref.update(data);
  }

  @override
  Future<void> delete(String id) async {
    await audioLogsTable.doc(id).delete();
  }
}