import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slack_cards/screens/website/read_card.dart';
import '../signup_email_password_screen.dart';

class ReadProfile extends StatelessWidget {
  ReadProfile({Key? key, this.args}) : super(key: key);
  static String routeName = '/u';
  String? args;

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    late DocumentSnapshot? documentSnapshot;
    final db = FirebaseFirestore.instance;
    String profilePictureURL = "";
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailPasswordSignup(),
                  ),
                );
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => const EmailPasswordSignup(),
                //   ),
                // );
              },
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: StreamBuilder(
          stream:
              db.collection('cards').where('id', isEqualTo: args!).snapshots(),
          // db
          //     .collection('cards')
          //     .where('id', isEqualTo: "HlNWb57QZIWRtyWnbAts4U1ZeAt1")
          //     .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              // print(
              //     'documentSnapshot ' + snapshot.data!.docs.length.toString());
              documentSnapshot = snapshot.data!.docs[0];
              if (documentSnapshot != null) {
                profilePictureURL = documentSnapshot!['profilePictureURL'];
                fullNameController.text = documentSnapshot!['fullName'];
                jobTitleController.text = documentSnapshot!['jobTitle'];
                descriptionController.text = documentSnapshot!['description'];
                phoneNumberController.text =
                    documentSnapshot!['phoneNumber'].toString();
              }

              return ReadCard(
                uid: args!,
                profilePictureURL: profilePictureURL,
                fullNameController: fullNameController,
                jobTitleController: jobTitleController,
                descriptionController: descriptionController,
                phoneNumberController: phoneNumberController,
                action: 'Actualizar',
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
