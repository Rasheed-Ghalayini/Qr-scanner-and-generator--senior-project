import 'dart:io';

import 'package:barcode_image/barcode_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Mat;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as Image;
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


class Functions{
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

  void _shareFile(String result, bool text) async {
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

}