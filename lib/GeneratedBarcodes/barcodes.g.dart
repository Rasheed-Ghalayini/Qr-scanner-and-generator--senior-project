// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcodes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeAdapter extends TypeAdapter<Barcodes> {
  @override
  final int typeId = 1;

  @override
  Barcodes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Barcodes(
      content: fields[4] as String,
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Barcodes obj) {
    writer
      ..writeByte(2)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
