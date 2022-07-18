import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slack_cards/screens/website/read_card.dart';

import '../../models/card_model.dart';
import 'screen_arguments.dart';

class ReadProfile extends StatelessWidget {
  ReadProfile({Key? key, this.args}) : super(key: key);
  static String routeName = '/u';
  //               print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
  //             print(Uri.base.query);  // id=15&randomNumber=3.14
  // print(Uri.base.queryParameters['randomNumber']);
  String? args;
  @override
  Widget build(BuildContext context) {
    // if(args == null){
    // }
    String _profilePic = "";
    String profilePictureURL = "";
    TextEditingController fullNameController = TextEditingController();
    
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    String action = "";
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot? documentSnapshot;
    UserCard userCard;
    print("args in build " + args!);
    return MaterialApp(
      title: 'Welcome to Slack Cards Clone',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Slack Cards Clone'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: db
              .collection('cards')
              // .where("id", isEqualTo: Uri.base.queryParameters['id'])
              // .doc(Uri.base.queryParameters['id'])
              .doc(args!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var documentSnapshot = snapshot.data!;
              var map = Map<String, dynamic>.from(
                  documentSnapshot.data() as Map<dynamic, dynamic>);
              userCard = UserCard.fromFirestore(Map.from(map));
              action = 'update';
              profilePictureURL = documentSnapshot['profilePictureURL'];
              fullNameController.text = documentSnapshot['fullName'];
              jobTitleController.text = documentSnapshot['jobTitle'];
              descriptionController.text = documentSnapshot['description'];
              phoneNumberController.text =
                  documentSnapshot['phoneNumber'].toString();
              // return Container();
              return ReadCard(
                // uid: Uri.base.queryParameters['id']!,
                uid: documentSnapshot['id'],
                profilePictureURL: profilePictureURL,
                fullNameController: fullNameController,
                jobTitleController: jobTitleController,
                descriptionController: descriptionController,
                phoneNumberController: phoneNumberController,
                action: action,
                db: db,
                documentSnapshot: documentSnapshot,
              );
            } else {
              return const Center(
                child:
                    Text('Ingresa una URL de usuario para ver su información'),
              );
            }
          },
        ),
      ),
    );
  }
}
