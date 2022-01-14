// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDataAdapter extends TypeAdapter<OrderData> {
  @override
  final int typeId = 2;

  @override
  OrderData read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderData(
      type: fields[4] as OrderDataTypes,
      price: fields[2] as double,
      amount: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
