// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_book_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Adapter for order book response.
class OrderBookResponseAdapter extends TypeAdapter<OrderBookResponse> {
  @override
  final int typeId = 0;

  @override
  OrderBookResponse read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderBookResponse(
      topic: fields[2] as String,
      action: fields[3] as String,
      symbol: fields[4] as String,
      data: fields[5] as OrderBookData?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderBookResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.topic)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.symbol)
      ..writeByte(5)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderBookResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
