
import 'dart:core';

import 'package:hive/hive.dart';
part 'barcodes.g.dart';
@HiveType(typeId: 1,adapterName: 'BarcodeAdapter')
class Barcodes{
  @HiveField(4)
  final String content;
  @HiveField(5)
  final String type;
  Barcodes({
    required this.content,
    required this.type,
  });

}