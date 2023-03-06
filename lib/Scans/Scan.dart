// ignore_for_file: file_names

import 'dart:core';

import 'package:hive/hive.dart';


part 'Scan.g.dart';

@HiveType(typeId: 0,adapterName: 'ScanAdapter')
class Scan{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String type;
  Scan({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
  });

}