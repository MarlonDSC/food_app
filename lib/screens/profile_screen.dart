// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/food_preferences.dart';
import 'package:provider/provider.dart';
import '../models/user_ingredient_model.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_methods.dart';
import 'card_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.enabled, this.argument})
      : super(key: key);
  final bool? enabled;
  final String? argument;
  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    String uid = "";
    try {
      uid = context.read<FirebaseAuthMethods>().user.uid;
    } catch (e) {
      uid = "";
    }

    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController jobTitleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    List liked;
    List<UserIngredientModel> userIngredient;
    List cuisine;
    late DocumentSnapshot documentSnapshot;
    final db = FirebaseFirestore.instance;
    String profilePictureURL = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodPreferences(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_suggest,
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db
              .collection('users')
              .doc(uid == "" ? argument : uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              documentSnapshot = snapshot.data!;
              profilePictureURL = documentSnapshot['profilePictureURL'];
              fullNameController.text = documentSnapshot['fullName'];
              jobTitleController.text = documentSnapshot['jobTitle'];
              descriptionController.text = documentSnapshot['description'];
              phoneNumberController.text =
                  documentSnapshot['phoneNumber'].toString();
              liked = documentSnapshot['liked'];
              cuisine = documentSnapshot['cuisine'];
              // userIngredient = documentSnapshot['userIngredient'];
              userIngredient = List<UserIngredientModel>.from(
                documentSnapshot['userIngredient']?.map(
                  (p) => UserIngredientModel.fromFirestore(p),
                ),
              );
              Provider.of<UserProvider>(context, listen: false)
                  .readFromFirestore(
                UserModel(
                  id: documentSnapshot['id'],
                  fullName: fullNameController.text,
                  jobTitle: jobTitleController.text,
                  description: descriptionController.text,
                  phoneNumber: phoneNumberController.text,
                  profilePictureURL: profilePictureURL,
                  liked: liked,
                  userIngredient: userIngredient,
                  cuisine: cuisine,
                ),
              );
              return CardForm(
                uid: uid,
                profilePictureURL: profilePictureURL,
                fullNameController: fullNameController,
                jobTitleController: jobTitleController,
                descriptionController: descriptionController,
                phoneNumberController: phoneNumberController,
                liked: liked,
                userIngredient: userIngredient,
                cuisine: cuisine,
                action: 'Update',
                db: db,
                documentSnapshot: documentSnapshot,
                enabled: enabled,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
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
