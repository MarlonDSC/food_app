import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/storage_methods.dart';
import '../widgets/custom_textfield.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

Future<String> uploadImage(Uint8List file) async {
  try {
    return await StorageMethods()
        .uploadImageToStorage('profilePics', file, false);
  } catch (e) {
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

Column createUpdateProfile(
  TextEditingController fullNameController,
  TextEditingController jobTitleController,
  TextEditingController descriptionController,
  TextEditingController phoneNumberController,
  bool enabled,
) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: fullNameController,
          hintText: 'Ingresa tu nombre',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.person),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: jobTitleController,
          hintText: 'Ingresa tu puesto de trabajo',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.work),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: descriptionController,
          hintText: 'Ingresa una descripción',
          textInputType: TextInputType.text,
          obscureText: false,
          prefix: const Icon(Icons.description),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          controller: phoneNumberController,
          hintText: 'Ingresa tu número de teléfono',
          textInputType: TextInputType.phone,
          obscureText: false,
          prefix: const Icon(Icons.call),
          suffix: const SizedBox(),
          enabled: enabled,
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

void saveTextFile(String text, String filename) {
  AnchorElement()
    ..href =
        // '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: utf8)}'
        '${Uri.dataFromString(text, mimeType: 'text/x-vcard', encoding: utf8)}'
    // '${Uri.dataFromString(text, mimeType: 'text/vcard', encoding: utf8)}'
    ..download = filename
    ..style.display = 'none'
    ..click();
}
