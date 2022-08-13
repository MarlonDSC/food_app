// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_methods.dart';
import 'card_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'signup_email_password_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.enabled, this.argument})
      : super(key: key);
  final bool? enabled;
  final String? argument;
  late String uid = "";
  @override
  Widget build(BuildContext context) {
    try {
      uid = context.read<FirebaseAuthMethods>().user.uid;
    } catch (e) {
      uid = "";
    }

    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController jobTitleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    late QueryDocumentSnapshot<Object?> documentSnapshot;
    final db = FirebaseFirestore.instance;
    String profilePictureURL = "";
    return StreamBuilder(
        stream: db
            .collection('users')
            .where(
              'id',
              isEqualTo: uid == "" ? argument : uid,
            )
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            documentSnapshot = snapshot.data!.docs[0];

            profilePictureURL = documentSnapshot['profilePictureURL'];
            fullNameController.text = documentSnapshot['fullName'];
            jobTitleController.text = documentSnapshot['jobTitle'];
            descriptionController.text = documentSnapshot['description'];
            phoneNumberController.text =
                documentSnapshot['phoneNumber'].toString();

            return CardForm(
              uid: uid,
              profilePictureURL: profilePictureURL,
              fullNameController: fullNameController,
              jobTitleController: jobTitleController,
              descriptionController: descriptionController,
              phoneNumberController: phoneNumberController,
              action: 'Actualizar',
              db: db,
              documentSnapshot: documentSnapshot,
              enabled: enabled,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // return Scaffold(
    //   appBar: AppBar(
    //     actions: [
    //       uid == "" || enabled == false
    //           ? IconButton(
    //               onPressed: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const EmailPasswordSignup(),
    //                   ),
    //                 );
    //               },
    //               icon: const Icon(Icons.person_add),
    //             )
    //           : IconButton(
    //               onPressed: () {
    //                 context.read<FirebaseAuthMethods>().signOut(context);
    //               },
    //               icon: const Icon(Icons.exit_to_app),
    //             ),
    //     ],
    //   ),
    //   body:
    // );
  }
}
