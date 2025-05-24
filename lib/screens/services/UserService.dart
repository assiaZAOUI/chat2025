import 'package:chat2025/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

enum StateRegistration { COMPLETE, IN_PROGRESS }

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<UserModel> get user {
    return _auth.authStateChanges().asyncMap(
      (user) =>
          UserModel(uid: user?.uid, email: user?.email ?? '', password: ''),
    );
  }

  Future<UserModel> auth(UserModel userModel) async {
    UserCredential userCredential;
    bool isNewUser = false;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } catch (e) {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      isNewUser = true;
    }

    userModel.setUid = userCredential.user!.uid;
    if (isNewUser) {
      await mailinglist(userModel.email);
    }
    return userModel;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<StateRegistration> mailinglist(
    String email, {
    StateRegistration? stateRegistration,
  }) async {
    DocumentReference documentReference = _firestore
        .collection('mailinglist')
        .doc(email);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (stateRegistration != null) {
      await _firestore.collection('mailinglist').doc(email).set({
        'state': stateRegistration.toString(),
      });
      return stateRegistration;
    }

    if (documentSnapshot.exists) {
      String state = documentSnapshot.get('state');

      return StateRegistration.values.firstWhere(
        (element) => element.toString() == state,
      );
    }

    await documentReference.set({
      'state': StateRegistration.IN_PROGRESS.toString(),
    });

    return StateRegistration.COMPLETE;
  }
}
