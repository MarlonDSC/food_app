import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:slack_cards/screens/home_screen.dart';
import 'package:slack_cards/screens/website/read_profile.dart';
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
  static String routeName = '/cardShare';
  CardShare({
    Key? key,
    required this.cardDocument,
    required this.profilePictureURL,
    required this.db,
    required this.enabled,
    // required this.documentSnapshot,
  }) : super(key: key);

  final String cardDocument;
  late String profilePictureURL;
  final FirebaseFirestore db;
  final bool enabled;
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
    if (widget.profilePictureURL.isEmpty) {
      return Container(
        color: Colors.white,
        child: PrettyQr(
          size: 400,
          data: fullURL,
          errorCorrectLevel: QrErrorCorrectLevel.H,
          typeNumber: null,
          roundEdges: true,
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: PrettyQr(
          image: NetworkImage(widget.profilePictureURL),
          size: 400,
          data: fullURL,
          errorCorrectLevel: QrErrorCorrectLevel.H,
          typeNumber: null,
          roundEdges: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(
                Icons.qr_code,
                size: 40,
              ),
              title: widget.enabled
                  ? const Text(
                      'Comparte tu perfil',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )
                  : const Text(
                      'Comparte el perfil',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
            ),
            // Center(
            //   child: QRcode(),
            // ),
            Center(
              child: RepaintBoundary(
                key: _renderObjectKey,
                child: QRcode(),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    TextButton(
                      child: Text(
                        'Copiar dirección'.toUpperCase(),
                      ),
                      onPressed: () {
                        // FlutterClipboard.copy(controller.text);
                        Clipboard.setData(ClipboardData(text: fullURL));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡URL copiada al portapapeles! 📃'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    widget.enabled
                        ? TextButton(
                            child: Text(
                              'Visualizar mi perfil'.toUpperCase(),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    enabled: false,
                                    argument: widget.cardDocument,
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     IconButton(
                //       onPressed: () {

                //       },
                //       icon: Icon(
                //         Icons.contact_mail,
                //         color: Theme.of(context).primaryColor,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
