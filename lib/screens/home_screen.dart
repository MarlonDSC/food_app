// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../services/firebase_auth_methods.dart';
import 'card_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'card_share.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController jobTitleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    late QueryDocumentSnapshot<Object?> documentSnapshot;
    final db = FirebaseFirestore.instance;
    String profilePictureURL = "";
    UserCard userCard;

    void _shareProfile([DocumentSnapshot? documentSnapshot]) async {
      String profilePictureURL = "";
      String cardDocument = "";
      if (documentSnapshot != null) {
        profilePictureURL = documentSnapshot['profilePictureURL'];
        cardDocument = documentSnapshot.id;
      }
      String action = 'create';
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return CardShare(
              cardDocument: cardDocument,
              profilePictureURL: profilePictureURL,
              db: db,
              // documentSnapshot: documentSnapshot,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            _shareProfile(documentSnapshot);
          },
        ),
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
              .where('id', isEqualTo: user.uid)
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
                user: user,
                profilePictureURL: profilePictureURL,
                fullNameController: fullNameController,
                jobTitleController: jobTitleController,
                descriptionController: descriptionController,
                phoneNumberController: phoneNumberController,
                action: 'update',
                db: db,
                documentSnapshot: documentSnapshot,
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
