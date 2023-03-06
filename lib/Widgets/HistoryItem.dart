// ignore_for_file: file_names

import 'package:senior_barcode/Screens/ResultScreen.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../Scans/Scan.dart';


class HistoryItem extends StatelessWidget {
  final Scan scan;

  const HistoryItem({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanResult(result: scan))
            // MaterialPageRoute(builder: (context) => ScanResult(result:)),
          );
        },
        child: Container(
          decoration: BoxDecoration(border:Border.all(color: Colors.black45),color: Colors.white30,borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom:8.0),
              //     child: BarcodeWidget(
              //       barcode: Barcode.qrCode(
              //         errorCorrectLevel: BarcodeQRCorrectionLevel.high,
              //       ),
              //       data: scan.content,
              //       width: 150,
              //       height: 150,
              //     ),
              //   ),
              // ),
              Center(child: Text(scan.content,style: const TextStyle(fontSize: 12.0),textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ),
    );
  }
}
