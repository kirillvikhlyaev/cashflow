// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlipAdapter extends TypeAdapter<Slip> {
  @override
  final int typeId = 0;

  @override
  Slip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Slip(
      name: fields[0] as String,
      cost: fields[1] as int,
      type: fields[2] as String,
      date: fields[3] as DateTime,
      startSlipDate: fields[4] as DateTime,
      isEnabledNotification: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Slip obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.cost)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.startSlipDate)
      ..writeByte(5)
      ..write(obj.isEnabledNotification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
