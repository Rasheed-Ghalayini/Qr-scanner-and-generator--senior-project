// ignore_for_file: file_names

import 'dart:io';

// ignore: library_prefixes
import 'package:senior_barcode/Widgets/resulttype.dart' as ResType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Mat;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../GeneratedBarcodes/barcodes.dart';
import '../Scans/Scan.dart';
import 'package:share_plus/share_plus.dart';

// ignore: library_prefixes
import 'package:image/image.dart' as Image;
import 'package:barcode_image/barcode_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GeneratedScreen extends StatefulWidget {
  const GeneratedScreen({super.key, required this.result});

  // const ScanResult({super.key});
  final Barcodes result;

  @override
  State<GeneratedScreen> createState() => _GeneratedScreenState();
}

_launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

_launchContactUrl(Barcodes result) async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File vcf =
  await File('$tempPath/${DateTime.now().millisecondsSinceEpoch}.vcf')
      .writeAsString(result.content);
  // await Share.shareXFiles([XFile(vcf.path)]);
  OpenFile.open(vcf.path, type: 'text/x-vcard');
  // VCard vCard = VCard(result.content);
  // vCard.print_lines();
  // VC.VCard vc = VC.VCard();
  // print(vCard.toString());
  // vc.saveToFile(filename);

  //
  // vCard.
  // if (await canLaunchUrl(url)) {
  //   await launchUrl(
  //     url,
  //     mode: LaunchMode.externalNonBrowserApplication,
  //   );
  // } else {
  //   throw 'Could not launch $url';
  // }
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

Future<File> _generateBarcode(Barcodes result, bool withText) async {
  List<dynamic> res = fixString(result.content, 300);
  int height = (res[1] * 25 + 600).floor();
  final image = Image.Image(600, height);
  if (kDebugMode) {
    print("jo${fixString(result.content, 300)}");
  }
  // Fill it with a solid color (white)
  Image.fill(image, getColor(255, 255, 255));
  // Draw the barcode
  const TextStyle textStyle = TextStyle(
    fontSize: 30,
    color: Colors.white,
  );
  if (kDebugMode) {
    print(_textSize(result.content, textStyle));
  }
  drawBarcode(image, Barcode.qrCode(), result.content,
      font: arial_24, x: 150, y: 150, width: 300, height: 300);
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
  await File('$tempPath/${DateTime.now().millisecondsSinceEpoch}.png')
      .writeAsBytes(encodePng(image));
  return file;
}

_saveToGalleryAsPng(Barcodes result) async {
  File file = await _generateBarcode(result, true);
  bool? saved = await GallerySaver.saveImage(file.path);
}

_shareFile(Barcodes result, bool text) async {
  // Create an image
  File file = await _generateBarcode(result, text);
  // bool? saved = await GallerySaver.saveImage(file.path);
  // print(saved);
  //await Share.shareFiles(['/yourPath/myItem.png'], text: 'Image Shared');
  if (text) {
    await Share.shareXFiles([XFile(file.path)], text: result.content);
  } else {
    await Share.shareXFiles([XFile(file.path)]);
  }
}

_shareContent(Barcodes result) async {
  // Create an image
  File file = await _generateBarcode(result, true);
  // bool? saved = await GallerySaver.saveImage(file.path);
  // print(saved);
  //await Share.shareFiles(['/yourPath/myItem.png'], text: 'Image Shared');
  await Share.share(result.content);
}

bool hasValidUrl(String value) {
  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  // ignore: unnecessary_new
  RegExp regExp = new RegExp(pattern);
  if (value.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

class _GeneratedScreenState extends State<GeneratedScreen> {
  bool isUri = false;
  Uri? uri;
  bool isContact = false;
  bool isPhone = false;
  bool isYoutube = false;
  bool isInstagram = false;
  bool isFacebook = false;
  bool isWifi = false;
  bool isEmail = false;
  bool isWhatsapp = false;
  bool isTwitter = false;

  @override
  void initState() {
    // TODO: implement initState
    isContact = widget.result.content.contains("VCARD") &&
        widget.result.content.contains("END:VCARD");
    if (kDebugMode) {
      if (kDebugMode) {
        print(widget.result.content);
      }
    }
    isEmail = widget.result.content.toLowerCase().startsWith("mailto:");
    isUri = hasValidUrl(widget.result.content) && !isEmail;
    isPhone = widget.result.content.toLowerCase().startsWith("tel:");
    isInstagram =
        widget.result.content.toLowerCase().startsWith("instagram://");
    isFacebook = widget.result.content.toLowerCase().startsWith("fb://");
    isTwitter = widget.result.content.toLowerCase().startsWith("twitter://");
    isYoutube = widget.result.content
        .toLowerCase()
        .contains("www.youtube.com/channel/");
    isWifi = widget.result.content.toLowerCase().startsWith("wifi:s:");
    isWhatsapp = widget.result.content.toLowerCase().startsWith("whatsapp://");
    uri = Uri.tryParse(widget.result.content);
    if (kDebugMode) {
      print(hasValidUrl(widget.result.content));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResType.ResultType(
                isPhone: isPhone,
                isUrl: isUri,
                isContact: isContact,
                isInstagram: isInstagram,
                isFacebook: isFacebook,
                isYoutube: isYoutube,
                isWifi: isWifi,
                isWhatsapp: isWhatsapp,
                isEmail: isEmail,
                isTwitter: isTwitter,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarcodeWidget(
                    barcode: Barcode.qrCode(
                      errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                    ),
                    data: widget.result.content,
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Center(
                    //     child: Text(
                    //   "Result",
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     color: Colors.black,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // )),
                    Text(
                      widget.result.content,
                      style:
                      const TextStyle(fontSize: 18, color: Colors.black45),
                    ),
                    isFacebook
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Mat.Color(0xff3b5998),
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const FaIcon(FontAwesomeIcons.facebook),
                        label: const Text("Open In Facebook"),
                      ),
                    )
                        : Container(),
                    isInstagram
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Mat.Color(0xffdd2a7b),
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const FaIcon(FontAwesomeIcons.instagram),
                        label: const Text("Visit Instagram Page"),
                      ),
                    )
                        : Container(),
                    isYoutube
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Mat.Color(0xFFFF0000),
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const FaIcon(FontAwesomeIcons.youtube),
                        label: const Text("Open Channel"),
                      ),
                    )
                        : Container(),
                    isUri
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const Icon(Icons.search),
                        label: const Text("Search In Browser"),
                      ),
                    )
                        : Container(),
                    isEmail
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45,
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const Icon(Icons.email),
                        label: const Text("Send Email"),
                      ),
                    )
                        : Container(),
                    isWhatsapp
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Mat.Color(0xff128c7e),
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const FaIcon(FontAwesomeIcons.whatsapp),
                        label: const Text("Open Whatsapp Chat"),
                      ),
                    )
                        : Container(),
                    isPhone
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchURL(uri ?? Uri.parse(""));
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text("Dial Number"),
                      ),
                    )
                        : Container(),
                    isContact
                        ? Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          await _launchContactUrl(widget.result);
                        },
                        icon: const Icon(Icons.person),
                        label: const Text("Import Contact Vcard"),
                      ),
                    )
                        : Container(),
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
                              ClipboardData(text: widget.result.content));
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
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Save Barcode"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
