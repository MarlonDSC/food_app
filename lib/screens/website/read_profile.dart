import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slack_cards/screens/website/read_card.dart';
import '../../models/card_model.dart';
import '../card_form.dart';
import '../card_share.dart';
import '../signup_email_password_screen.dart';
import 'screen_arguments.dart';

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
    UserCard userCard;
    print("args in build " + args!);

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
              enabled: true,
              // documentSnapshot: documentSnapshot,
            );
          });
    }

    print("args " + args.toString());
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
              var map = Map<String, dynamic>.from(
                  documentSnapshot!.data() as Map<dynamic, dynamic>);
              userCard = UserCard.fromFirestore(Map.from(map));

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
