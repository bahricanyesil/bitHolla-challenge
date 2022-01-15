// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_book_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Adapter for order book.
class OrderBookDataAdapter extends TypeAdapter<OrderBookData> {
  @override
  final int typeId = 1;

  @override
  OrderBookData read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderBookData(
      bids: (fields[2] as List<OrderData>).cast<OrderData>(),
      asks: (fields[3] as List<OrderData>).cast<OrderData>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderBookData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.bids)
      ..writeByte(3)
      ..write(obj.asks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderBookDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
