import 'package:cloud_firestore/cloud_firestore.dart';

class CommonService {
  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance; // Initialize Firestore instance
  Future<String> get terms async {
    await Future.delayed(Duration(seconds: 5));
    String content = "";
    DocumentReference documentReference = _firebaseFirestore
        .collection('commons')
        .doc('terms');
    content = (await documentReference.get()).get('content');
    return content;
  }
}
