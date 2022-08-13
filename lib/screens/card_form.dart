import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/card_model.dart';
import '../services/storage_methods.dart';
import '../utils/show_snackbar.dart';
import '../utils/utils.dart';

class CardForm extends StatefulWidget {
  const CardForm({
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
    required enabled,
  })  : _profilePic = profilePictureURL,
        _fullNameController = fullNameController,
        _jobTitleController = jobTitleController,
        _descriptionController = descriptionController,
        _phoneNumberController = phoneNumberController,
        _enabled = enabled,
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
  final bool _enabled;

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  late Uint8List localProfilePic = convertStringToUint8List("");

  Future<String> uploadImage(Uint8List file) async {
    try {
      return await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
    } catch (e) {
      return "";
    }
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
                      widget._enabled
                          ? Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () async {
                                  localProfilePic =
                                      await pickImage(ImageSource.gallery);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                createUpdateProfile(
                  widget._fullNameController,
                  widget._jobTitleController,
                  widget._descriptionController,
                  widget._phoneNumberController,
                  widget._enabled,
                ),
              ],
            ),
          ),
          widget._enabled
              ? SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    child:
                        Text(widget.action == 'Crear' ? 'Crear' : 'Actualizar'),
                    onPressed: () async {
                      userCard = UserCard(
                        id: widget.uid,
                        fullName: widget._fullNameController.text,
                        jobTitle: widget._jobTitleController.text,
                        description: widget._descriptionController.text,
                        phoneNumber: widget._phoneNumberController.text,
                        profilePictureURL: await emptyOrSameImage(),
                      );
                      if (userCard.fullName != null &&
                          userCard.jobTitle != null) {
                        if (widget.action == 'Crear') {
                          // Persist a new product to Firestore
                          await widget.db
                              .collection('users')
                              .doc(userCard.id)
                              .set(userCard.toFirestore());
                        }

                        if (widget.action == 'Actualizar') {
                          // Update the product
                          await widget.db
                              .collection('users')
                              .doc(widget.documentSnapshot!.id)
                              .update(userCard.toFirestore());
                          showSnackBar(context, '¡Datos actualizados!');
                        }
                        localProfilePic = convertStringToUint8List("");
                      }
                    },
                  ),
                )
              : const SizedBox(
                  width: double.infinity,
                  height: 55,
                ),
        ],
      ),
    );
  }
}
