// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../services/firebase_auth_methods.dart';
import 'card_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'card_share.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, this.enabled, this.argument}) : super(key: key);
  final bool? enabled;
  final String? argument;
  late String uid = "";
  @override
  Widget build(BuildContext context) {
    try {
      uid = context.read<FirebaseAuthMethods>().user.uid;
    } catch (e) {
      print(e.toString());
    }

    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController jobTitleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    late QueryDocumentSnapshot<Object?> documentSnapshot;
    final db = FirebaseFirestore.instance;
    String profilePictureURL = "";
    UserCard userCard;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<FirebaseAuthMethods>().signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: db
              .collection('cards')
              .where(
                'id',
                isEqualTo: uid == "" ? argument : uid,
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              documentSnapshot = snapshot.data!.docs[0];
              var map = Map<String, dynamic>.from(
                  documentSnapshot.data() as Map<dynamic, dynamic>);
              userCard = UserCard.fromFirestore(Map.from(map));
              print(documentSnapshot['fullName']);

              if (documentSnapshot != null) {
                profilePictureURL = documentSnapshot['profilePictureURL'];
                fullNameController.text = documentSnapshot['fullName'];
                jobTitleController.text = documentSnapshot['jobTitle'];
                descriptionController.text = documentSnapshot['description'];
                phoneNumberController.text =
                    documentSnapshot['phoneNumber'].toString();
              }

              return CardForm(
                uid: uid,
                profilePictureURL: profilePictureURL,
                fullNameController: fullNameController,
                jobTitleController: jobTitleController,
                descriptionController: descriptionController,
                phoneNumberController: phoneNumberController,
                action: 'update',
                db: db,
                documentSnapshot: documentSnapshot,
                enabled: enabled,
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('Add a new user'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
