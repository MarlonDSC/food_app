import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slack_cards/services/storage_methods.dart';
import 'package:image_picker/image_picker.dart';

import '../models/card_model.dart';
import '../utils/utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/services.dart';

class CardShare extends StatelessWidget {
  const CardShare({
    Key? key,
    required this.cardDocument,
    required this.profilePictureURL,
    required this.db,
    // required this.documentSnapshot,
  }) : super(key: key);

  final String cardDocument;
  final String profilePictureURL;
  final FirebaseFirestore db;
  // final DocumentSnapshot? documentSnapshot;

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
    String fullURL = "https://ionic-ec0mmerce.web.app/#/$cardDocument";
    print("cardDocument " + cardDocument);
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
            child: PrettyQr(
              image: NetworkImage(profilePictureURL),
              size: 300,
              data: fullURL,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              typeNumber: null,
              roundEdges: true,
            ),
          ),
          Center(
            child: Card(
              child: ListTile(
                title: const Text('Copia el link'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: fullURL));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
