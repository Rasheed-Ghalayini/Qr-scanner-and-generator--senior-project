import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../GeneratedBarcodes/barcodes.dart';
import '../Scans/Scan.dart';

class ScansDatabase {
  List<dynamic>? scans = [];
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    scans?.add(Scan(
        id: 1,
        title: 'Title 1',
        content: 'https://www.google.com',
        type: 'Type 1'));
    // scans?.add(
    //     Scan(id: 2, title: 'Title 2', content: 'Content 2', type: 'Type 2'));
    // scans?.add(
    //     Scan(id: 3, title: 'Title 3', content: 'Content 3', type: 'Type 3'));
    updateDatabase();
  }

  void loadData() {
    if (kDebugMode) {
      print(_myBox.get('SCANS'));
    }
    // List<Scan> temp = _myBox.get('SCANS') as List<Scan>;
    scans = _myBox.get('SCANS');
  }

  void updateDatabase() {
    _myBox.put('SCANS', scans);
    if (kDebugMode) {
      print(_myBox.get('SCANS'));
    }
  }

  void clearHistory() {
    scans?.clear();
    _myBox.put('SCANS', scans);
  }
}

class BarcodesDatabase {
  List<dynamic>? genBarcodes = [];
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    genBarcodes?.add(Barcodes(content: 'https://www.google.com', type: 'URL'));
    // genBarcodes?.add(Barcodes(content: 'Content 2', type: 'Type 2'));
    // genBarcodes?.add(Barcodes(content: 'Content 3', type: 'Type 3'));
    updateDatabase();
  }

  void loadData() {
    if (kDebugMode) {
      print(_myBox.get('BARCODES'));
    }
    // List<Scan> temp = _myBox.get('SCANS') as List<Scan>;
    genBarcodes = _myBox.get('BARCODES');
  }

  void updateDatabase() {
    _myBox.put('BARCODES', genBarcodes);
    if (kDebugMode) {
      print(_myBox.get('BARCODES'));
    }
  }

  void clearHistory() {
    genBarcodes?.clear();
    _myBox.put('BARCODES', genBarcodes);
  }
}
