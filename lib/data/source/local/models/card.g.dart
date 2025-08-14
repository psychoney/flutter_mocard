// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardHiveModelAdapter extends TypeAdapter<CardHiveModel> {
  @override
  final int typeId = 1;

  @override
  CardHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardHiveModel()
      ..number = fields[0] as String
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..role = (fields[3] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      ..demo = (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      ..imgUrl = fields[5] as String
      ..type = fields[6] as String
      ..color = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, CardHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.demo)
      ..writeByte(5)
      ..write(obj.imgUrl)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
