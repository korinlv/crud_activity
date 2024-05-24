import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  // Get the list of subjects from the database
  final CollectionReference subjects = FirebaseFirestore.instance.collection("subjects");

  // CREATE: add a new subject in the database
  Future<void> addSubject(String subject){
    return subjects.add({
      'subject': subject,
      'date_created': Timestamp.now(),
    });
  }

  // READ: call all the subjects in the database
  Stream<QuerySnapshot> getSubjectStream() {
    final subjectStream = 
      subjects.orderBy('date_created', descending: true).snapshots();

      return subjectStream;
  }

  // UPDATE: update subject based on the given ID
  Future<void> updateSubject(String docID, String newSubject) {
    return subjects.doc(docID).update({'subject': newSubject});
  }

  // DELETE: delete subject based on the given ID
  Future<void> deleteSubject(String docID) {
    return subjects.doc(docID).delete();
  }
}