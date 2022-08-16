import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';

import '../../services/storage_methods.dart';
import '../../utils/utils.dart';
// import '../utils/utils.dart';

class ReadCard extends StatefulWidget {
  const ReadCard({
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

  @override
  State<ReadCard> createState() => _ReadCardState();
}

class _ReadCardState extends State<ReadCard> {
  late Uint8List localProfilePic = convertStringToUint8List("");

  Future<String> uploadImage(Uint8List file) async {
    try {
      return await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                widget._profilePic == ""
                    ? CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('images/profile_pic.png'),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          widget._profilePic,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                // Positioned(
                //   bottom: -10,
                //   left: 80,
                //   child: IconButton(
                //     onPressed: () async {
                //       localProfilePic = await pickImage(ImageSource.gallery);
                //       print("localProfilePic " + localProfilePic.toString());
                //     },
                //     icon: const Icon(
                //       Icons.add_a_photo,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          TextField(
            readOnly: true,
            controller: widget._fullNameController,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
          ),
          TextField(
            readOnly: true,
            controller: widget._jobTitleController,
            decoration: const InputDecoration(labelText: 'Puesto de trabajo'),
          ),
          TextField(
            readOnly: true,
            controller: widget._descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextField(
            readOnly: true,
            keyboardType: const TextInputType.numberWithOptions(),
            controller: widget._phoneNumberController,
            decoration: const InputDecoration(labelText: 'Numero de teléfono'),
          ),
          const SizedBox(
            height: 20,
          ),
          // ElevatedButton(
          //   child: Text(action == 'create' ? 'Create' : 'Update'),
          //   onPressed: () async {
          //     print("localProfilePic " + localProfilePic.toString());
          //     userModel = userModel(
          //       id: uid,
          //       fullName: _fullNameController.text,
          //       jobTitle: _jobTitleController.text,
          //       description: _descriptionController.text,
          //       phoneNumber: int.parse(_phoneNumberController.text),
          //       profilePictureURL: await uploadImage(localProfilePic),
          //     );
          //     if (userModel.fullName != null && userModel.jobTitle != null) {
          //       if (action == 'create') {
          //         // Persist a new product to Firestore
          //         await db.collection('users').add(userModel.toFirestore());
          //       }

          //       if (action == 'update') {
          //         // Update the product
          //         await db
          //             .collection('users')
          //             .doc(documentSnapshot!.id)
          //             .update(userModel.toFirestore());
          //       }

          //       // Clear the text fields
          //       _fullNameController.text = '';
          //       _jobTitleController.text = '';
          //       _descriptionController.text = '';
          //       _phoneNumberController.text = '';
          //       // Hide the bottom sheet
          //       Navigator.of(context).pop();
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
