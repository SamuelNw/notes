import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  // Create a new note:
  void createNewNote({required String ownerUserId}) async {
    notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });
  }

  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
