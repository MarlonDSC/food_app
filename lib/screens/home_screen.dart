// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../services/firebase_auth_methods.dart';
import '../widgets/custom_button.dart';
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

    final db = FirebaseFirestore.instance;
    UserCard userCard;

    Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
      String action = 'create';
      String profilePictureURL = "";
      if (documentSnapshot != null) {
        action = 'update';
        profilePictureURL = documentSnapshot['profilePictureURL'];
        fullNameController.text = documentSnapshot['fullName'];
        jobTitleController.text = documentSnapshot['jobTitle'];
        descriptionController.text = documentSnapshot['description'];
        phoneNumberController.text = documentSnapshot['phoneNumber'].toString();
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return CardForm(
              uid: user.uid,
              profilePictureURL: profilePictureURL,
              fullNameController: fullNameController,
              jobTitleController: jobTitleController,
              descriptionController: descriptionController,
              phoneNumberController: phoneNumberController,
              action: action,
              db: db,
              documentSnapshot: documentSnapshot,
            );
          });
    }

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
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var documentSnapshot = snapshot.data!.docs[index];
                  var map = Map<String, dynamic>.from(
                      documentSnapshot.data() as Map<dynamic, dynamic>);
                  userCard = UserCard.fromFirestore(Map.from(map));
                  return Card(
                    child: ListTile(
                      // title: Text(documentSnapshot['name']),
                      title: Text(userCard.fullName!),
                      subtitle: Text(userCard.phoneNumber!.toString()),
                      leading: IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: () {
                          _shareProfile(documentSnapshot);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _createOrUpdate(documentSnapshot);
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('Add a new user'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );

            // return Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       // when user signs anonymously or with phone, there is no email
            //       if (!user.isAnonymous && user.phoneNumber == null)
            //         Text(user.email!),
            //       if (!user.isAnonymous && user.phoneNumber == null)
            //         Text(user.providerData[0].providerId),
            //       // display phone number only when user's phone number is not null
            //       if (user.phoneNumber != null) Text(user.phoneNumber!),
            //       // uid is always available for every sign in method
            //       Text(user.uid),
            //       // display the button only when the user email is not verified
            //       // or isnt an anonymous user
            //       if (!user.emailVerified && !user.isAnonymous)
            //         CustomButton(
            //           onTap: () {
            //             context
            //                 .read<FirebaseAuthMethods>()
            //                 .sendEmailVerification(context);
            //           },
            //           text: 'Verify Email',
            //         ),
            //       // CustomButton(
            //       //   onTap: () {
            //       //     context.read<FirebaseAuthMethods>().deleteAccount(context);
            //       //   },
            //       //   text: 'Delete Account',
            //       // ),
            //     ],
            //   ),
            // );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
