import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/card_model.dart';

class CardForm extends StatelessWidget {
  const CardForm({
    Key? key,
    required this.uid,
    required TextEditingController fullNameController,
    required TextEditingController jobTitleController,
    required TextEditingController descriptionController,
    required TextEditingController phoneNumberController,
    required this.action,
    required this.db,
    required this.documentSnapshot,
  })  : _fullNameController = fullNameController,
        _jobTitleController = jobTitleController,
        _descriptionController = descriptionController,
        _phoneNumberController = phoneNumberController,
        super(key: key);

  final String uid;
  final TextEditingController _fullNameController;
  final TextEditingController _jobTitleController;
  final TextEditingController _descriptionController;
  final TextEditingController _phoneNumberController;
  final String action;
  final FirebaseFirestore db;
  final DocumentSnapshot? documentSnapshot;
  @override
  Widget build(BuildContext context) {
    UserCard userCard;

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
              userCard = UserCard(
                id: uid,
                fullName: _fullNameController.text,
                jobTitle: _jobTitleController.text,
                description: _descriptionController.text,
                phoneNumber: int.parse(_phoneNumberController.text),
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
