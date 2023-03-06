import 'dart:io';

import 'package:barcode_image/barcode_image.dart';
import 'package:senior_barcode/data/database.dart';
import 'package:barcode_widget/barcode_widget.dart';
//import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Mat;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as Image;
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mailto/mailto.dart';

import '../../GeneratedBarcodes/barcodes.dart';

class CreateTwitterScreen extends StatefulWidget {
  const CreateTwitterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateTwitterScreenState createState() => _CreateTwitterScreenState();
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

List<dynamic> fixString(String str, int width) {
  var sb = StringBuffer();
  var count = 0;
  while (str.isNotEmpty) {
    if (str.length * 24 <= width) {
      sb.write(str);
      break;
    }
    var w = str.length < 24 ? str.length : 24;
    sb.write(str.substring(0, w));
    sb.write("\n");
    count++;
    str = str.substring(w);
  }
  return [sb.toString(), count];
}

Future<File> _generateBarcode(String result, bool withText) async {
  List<dynamic> res = fixString(result, 300);
  int height = (res[1] * 25 + 600).floor();
  final image = Image.Image(600, height);
  if (kDebugMode) {
    print("jo${fixString(result, 300)}");
  }
  // Fill it with a solid color (white)
  Image.fill(image, getColor(255, 255, 255));
  // Draw the barcode
  const TextStyle textStyle = TextStyle(
    fontSize: 30,
    color: Colors.white,
  );
  if (kDebugMode) {
    print(_textSize(result, textStyle));
  }
  drawBarcode(image, Barcode.qrCode(), result,
      font: arial_24,
      x: 150,
      y: 150,
      width: 300,
      height: 300);
  if (withText) {
    drawString(
      image,
      arial_24,
      150,
      470,
      res[0],
      color: getColor(0, 0, 0),
    );
  }
  Directory tempDir = await getTemporaryDirectory();
  Directory appDir = await getApplicationDocumentsDirectory();
  String tempPath = tempDir.path;
  String appPath = appDir.path;
  // Save the image
  if (kDebugMode) {
    print(tempPath);
  }
  if (kDebugMode) {
    print(appPath);
  }

  File file =
  await File('$tempPath/${DateTime
      .now()
      .millisecondsSinceEpoch}.png')
      .writeAsBytes(encodePng(image));
  return file;
}

_saveToGalleryAsPng(String result) async {
  File file = await _generateBarcode(result, true);
  bool? saved = await GallerySaver.saveImage(file.path);
}

_shareFile(String result, bool text) async {
  // Create an image
  File file = await _generateBarcode(result, text);
  // bool? saved = await GallerySaver.saveImage(file.path);
  // print(saved);
  //await Share.shareFiles(['/yourPath/myItem.png'], text: 'Image Shared');
  if (text) {
    await Share.shareXFiles([XFile(file.path)], text: result);
  } else {
    await Share.shareXFiles([XFile(file.path)]);
  }
}


class _CreateTwitterScreenState extends State<CreateTwitterScreen> {
  final _myBox = Hive.box('mybox');
  final myController = TextEditingController();
  String generatedText = "";
  BarcodesDatabase db = BarcodesDatabase();
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
    if (_myBox.get('BARCODES') == null) {
      if (kDebugMode) {
        print('hi');
      }
      // db.createInitialData();
      // print(_myBox.get('SCANS'));
    } else {
      //db.createInitialData();

      db.loadData();
    }
  }

  void _printLatestValue() {
    if (kDebugMode) {
      print('Second text field: ${myController.text}');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  Widget icon = const FaIcon(FontAwesomeIcons.twitter,color: Colors.white,);
  String name = "Twitter";
  Mat.Color color = const Mat.Color(0xff00acee);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Twitter QR Code"),
        ),
        body: ListView(
            children: [
        Column(
        children: [
        Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundColor: color, child: icon),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        )),
    Padding(
    padding: const EdgeInsets.all(28.0),
    child: Form(
      autovalidateMode: AutovalidateMode.always,
      child: TextFormField(
      decoration: const InputDecoration(labelText: 'Enter Twitter User'),
      controller: myController,
      // validator: (value) => validateEmail(value) ? null : "Please enter a valid email",

      ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(8),
    child: ElevatedButton(
    onPressed: () {
    setState(() {
    // if(myController.text.isNotEmpty && validateEmail(myController.text)) {
    generatedText = 'twitter://user?screen_name=${myController.text}';
    db.genBarcodes?.add(Barcodes(
    content: generatedText, type: "TWITTER"));
    db.updateDatabase();
    // }
    // else{
    //
    // }
    });
    },
    child: const Text("Generate QR Code"),
    )),
    generatedText != ""
    ? GeneratedQr(result: generatedText)
        : Container(),
    ],
    )
    ],
    ),

    );
    }
}

class GeneratedQr extends StatefulWidget {
  final String result;


  const GeneratedQr({Key? key, required this.result}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GeneratedQrState createState() => _GeneratedQrState();
}

class _GeneratedQrState extends State<GeneratedQr> {
  final _myBox = Hive.box('mybox');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right: 18.0,top:30,bottom:30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: BarcodeWidget(
                barcode: Barcode.qrCode(
                  errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                ),
                data: widget.result,
                width: 150,
                height: 150,
              ),
            ),
          ),
          Center(
              child: Text(
                widget.result,
                style: const TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                await _shareFile(widget.result, true);
              },
              icon: const Icon(Icons.share),
              label: const Text("Share Barcode With Text"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                await _shareFile(widget.result, false);
              },
              icon: const Icon(Icons.share),
              label: const Text("Share Barcode Only"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.result));
                Fluttertoast.showToast(
                    msg: "Copied To Clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black26,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              icon: const Icon(Icons.copy),
              label: const Text("Copy To Clipboard"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                await _saveToGalleryAsPng(widget.result);
                Fluttertoast.showToast(
                    msg: "Saved To Gallery",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black26,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              icon: const Icon(Icons.save),
              label: const Text("Save Barcode"),
            ),
          ),
        ],
      ),
    );
  }
}
bool validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return false;
  else
    return true;
}