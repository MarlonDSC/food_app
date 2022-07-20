import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/card_model.dart';
import '../services/storage_methods.dart';
import '../utils/showSnackbar.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';

class CardForm extends StatefulWidget {
  CardForm({
    Key? key,
    required this.user,
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

  final dynamic user;
  final String _profilePic;
  final TextEditingController _fullNameController;
  final TextEditingController _jobTitleController;
  final TextEditingController _descriptionController;
  final TextEditingController _phoneNumberController;
  final String action;
  final FirebaseFirestore db;
  final DocumentSnapshot? documentSnapshot;

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
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

  Future<String> emptyOrSameImage() async {
    if (convertUint8ListToString(localProfilePic) == "") {
      return widget.documentSnapshot!['profilePictureURL'];
    } else {
      return await uploadImage(localProfilePic);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserCard userCard;
    print("fullName " + widget.documentSnapshot!['fullName']);
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
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      widget._profilePic == ""
                          ? CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('images/profile_pic.png'),
                            )
                          : convertUint8ListToString(localProfilePic) == ""
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                    widget._profilePic,
                                  ),
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: MemoryImage(localProfilePic),
                                ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () async {
                            localProfilePic =
                                await pickImage(ImageSource.gallery);
                            print("localProfilePic " +
                                localProfilePic.toString());
                            setState(() {});
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
                  controller: widget._fullNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre completo'),
                ),
                TextField(
                  controller: widget._jobTitleController,
                  decoration:
                      const InputDecoration(labelText: 'Puesto de trabajo'),
                ),
                TextField(
                  controller: widget._descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: widget._phoneNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Numero de teléfono'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              child: Text(widget.action == 'create' ? 'Create' : 'Update'),
              onPressed: () async {
                print("localProfilePic " + localProfilePic.toString());
                userCard = UserCard(
                  id: widget.user.uid,
                  fullName: widget._fullNameController.text,
                  jobTitle: widget._jobTitleController.text,
                  description: widget._descriptionController.text,
                  phoneNumber: widget._phoneNumberController.text,
                  profilePictureURL: await emptyOrSameImage(),
                );
                if (userCard.fullName != null && userCard.jobTitle != null) {
                  if (widget.action == 'create') {
                    // Persist a new product to Firestore
                    await widget.db
                        .collection('cards')
                        .doc(userCard.id)
                        .set(userCard.toFirestore());
                  }

                  if (widget.action == 'update') {
                    // Update the product
                    await widget.db
                        .collection('cards')
                        .doc(widget.documentSnapshot!.id)
                        .update(userCard.toFirestore());
                    showSnackBar(context, '¡Datos actualizados!');
                  }
                  localProfilePic = convertStringToUint8List("");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
