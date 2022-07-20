import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';
import '../screens/card_share.dart';
import '../utils/showSnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  //State persistance
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  //Email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String fullName,
    required String jobTitle,
    required String description,
    required String phoneNumber,
    required String password,
    required String profilePicURL,
    required BuildContext context,
  }) async {
    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          jobTitle.isNotEmpty &&
          description.isNotEmpty &&
          phoneNumber.toString().isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        UserCard user = UserCard(
          id: _auth.currentUser!.uid,
          description: description,
          fullName: fullName,
          jobTitle: jobTitle,
          phoneNumber: phoneNumber,
          profilePictureURL: profilePicURL,
        );
        await _firestore
            .collection('cards')
            .doc(_auth.currentUser!.uid)
            .set(user.toFirestore());
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext ctx) {
              return CardShare(
                cardDocument: _auth.currentUser!.uid,
                profilePictureURL: profilePicURL,
                db: _firestore,
                // documentSnapshot: documentSnapshot,
              );
            });
      } else {
        showSnackBar(
          context,
          "Completa todos los campos para poder registrarte",
        );
      }

      // await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Email login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // if (!_auth.currentUser!.emailVerified) {
      //   await sendEmailVerification(context);
      // }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Email verification

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
