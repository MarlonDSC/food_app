import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:slack_cards/services/storage_methods.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:universal_io/io.dart';
import 'dart:html' as html;
import '../models/card_model.dart';
import '../utils/utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class CardShare extends StatefulWidget {
  CardShare({
    Key? key,
    required this.cardDocument,
    required this.profilePictureURL,
    required this.db,
    // required this.documentSnapshot,
  }) : super(key: key);

  final String cardDocument;
  late String profilePictureURL;
  final FirebaseFirestore db;
  @override
  State<CardShare> createState() => _CardShareState();
}

class _CardShareState extends State<CardShare> {
  late String fullURL =
      "https://build.sanjeronimostudio.com/#/${widget.cardDocument}";

  final _renderObjectKey = GlobalKey();
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

  // Future<Uint8List> _getWidgetImage() async {
  //   try {
  //     RenderRepaintBoundary? boundary = _renderObjectKey.currentContext!
  //         .findRenderObject() as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData!.buffer.asUint8List();
  //     var bs64 = base64Encode(pngBytes);
  //     debugPrint(bs64.length.toString());
  //     return pngBytes;
  //   } catch (exception) {
  //     print("exception" + exception.toString());
  //     return convertStringToUint8List("");
  //   }
  // }

  // Future<void> _getImage() async {
  //   RenderRepaintBoundary boundary = _renderObjectKey.currentContext!
  //       .findRenderObject() as RenderRepaintBoundary;
  //   var image = await boundary.toImage();

  //   if (kIsWeb) {
  //     print('registering as a web device');
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     final _base64 = base64Encode(pngBytes);
  //     final anchor = html.AnchorElement(
  //         href: 'data:application/octet-stream;base64,$_base64')
  //       ..download = "image.png"
  //       ..target = 'blank';

  //     html.document.body!.append(anchor);
  //     anchor.click();
  //     anchor.remove();
  //   }
  // }

  // Future<Uint8List> _getWidgetImage() async {
  Widget QRcode() {
    return Container(
      color: Colors.white,
      child: PrettyQr(
        image: NetworkImage(widget.profilePictureURL),
        size: 300,
        data: fullURL,
        errorCorrectLevel: QrErrorCorrectLevel.H,
        typeNumber: null,
        roundEdges: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("cardDocument " + widget.cardDocument);
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
          // Center(
          //   child: QRcode(),
          // ),
          Center(
            child: RepaintBoundary(
              key: _renderObjectKey,
              child: QRcode(),
            ),
          ),
          // Center(
          //   child: Card(
          //     child: ListTile(
          //       title: const Text('Copia o descarga la imagen'),
          //       trailing: IconButton(
          //         icon: const Icon(Icons.download),
          //         onPressed: () {
          //           _getImage();
          //         },
          //       ),
          //     ),
          //   ),
          // ),
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
