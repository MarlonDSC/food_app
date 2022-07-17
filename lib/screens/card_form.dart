import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/card_model.dart';
import '../services/storage_methods.dart';
import '../utils/utils.dart';

class CardForm extends StatelessWidget {
  CardForm({
    Key? key,
    required this.uid,
    required String profilePictureURL,
    required TextEditingController fullNameController,
    required TextEditingController jobTitleController,
    required TextEditingController descriptionController,
    required TextEditingController phoneNumberController,
    required this.action,
    required this.db,
    required this.documentSnapshot,
  })  : _profilePic = profilePictureURL,
        _fullNameController = fullNameController,
        _jobTitleController = jobTitleController,
        _descriptionController = descriptionController,
        _phoneNumberController = phoneNumberController,
        super(key: key);

  final String uid;
  final String _profilePic;
  final TextEditingController _fullNameController;
  final TextEditingController _jobTitleController;
  final TextEditingController _descriptionController;
  final TextEditingController _phoneNumberController;
  final String action;
  final FirebaseFirestore db;
  final DocumentSnapshot? documentSnapshot;
  late Uint8List localProfilePic = convertStringToUint8List("");

  Future<String> uploadImage(Uint8List file) async {
    String res = "Some error ocurred";
    try {
      return await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
    } catch (e) {
      res = e.toString();
      return "";
    }
  }

  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  String convertUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  @override
  Widget build(BuildContext context) {
    UserCard userCard;
    // Uint8List? localProfilePic;
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          // prevent the soft keyboard from covering text fields
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                _profilePic == "" || _profilePic == null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('images/profile_pic.png'),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          _profilePic,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () async {
                      localProfilePic = await pickImage(ImageSource.gallery);
                      print("localProfilePic " + localProfilePic.toString());
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                )
              ],
            ),
          ),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
          ),
          TextField(
            controller: _jobTitleController,
            decoration: const InputDecoration(labelText: 'Puesto de trabajo'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextField(
            keyboardType: const TextInputType.numberWithOptions(),
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Numero de teléfono'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Text(action == 'create' ? 'Create' : 'Update'),
            onPressed: () async {
              print("localProfilePic " + localProfilePic.toString());
              userCard = UserCard(
                id: uid,
                fullName: _fullNameController.text,
                jobTitle: _jobTitleController.text,
                description: _descriptionController.text,
                phoneNumber: int.parse(_phoneNumberController.text),
                profilePictureURL: await uploadImage(localProfilePic),
              );
              if (userCard.fullName != null && userCard.jobTitle != null) {
                if (action == 'create') {
                  // Persist a new product to Firestore
                  await db.collection('cards').add(userCard.toFirestore());
                }

                if (action == 'update') {
                  // Update the product
                  await db
                      .collection('cards')
                      .doc(documentSnapshot!.id)
                      .update(userCard.toFirestore());
                }

                // Clear the text fields
                _fullNameController.text = '';
                _jobTitleController.text = '';
                _descriptionController.text = '';
                _phoneNumberController.text = '';
                // Hide the bottom sheet
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}
