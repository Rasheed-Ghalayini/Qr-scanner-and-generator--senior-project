// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Scan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanAdapter extends TypeAdapter<Scan> {
  @override
  final int typeId = 0;

  @override
  Scan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scan(
      id: fields[0] as int,
      title: fields[1] as String,
      content: fields[2] as String,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Scan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
