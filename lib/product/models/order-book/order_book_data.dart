import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/extensions/date/date_time_extensions.dart';
import '../../../../core/helpers/hasher.dart';
import '../../../core/base/model/base_model.dart';
import '../../constants/enums/order_data_types.dart';
import '../../managers/local-storage/hive_configs.dart';
import 'order_data.dart';

part 'order_book_data.g.dart';

@HiveType(typeId: HiveConfigs.orderBookData)

/// [OrderBookData] model is to store the information about a orderBookData.
class OrderBookData with HiveObjectMixin implements BaseModel<OrderBookData> {
  /// Default constructor for [OrderBookData].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  OrderBookData({
    this.bids = const <OrderData>[],
    this.asks = const <OrderData>[],
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now();

  /// Mock object, dummy data for [OrderBookData].
  OrderBookData.mock({
    List<OrderData>? bids,
    List<OrderData>? asks,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now(),
        bids = bids ?? <OrderData>[],
        asks = asks ?? <OrderData>[];

  factory OrderBookData.fromJson(Map<String, dynamic> json) {
    final List<OrderData> bids = _toDataBidList(json['bids'])
      ..sort((OrderData a, OrderData b) => a.price < b.price ? 1 : 0);
    final List<OrderData> asks = _toDataAskList(json['asks'])
      ..sort((OrderData a, OrderData b) => a.price > b.price ? 1 : 0);
    return OrderBookData(bids: bids, asks: asks);
  }

  /// Unique id of the orderBookData.
  @HiveField(0)
  final String id;

  /// The date when the orderBookData is created.
  @HiveField(1)
  final DateTime createdAt;

  /// List of bids for this data.
  @HiveField(2)
  final List<OrderData> bids;

  /// List of asks for this data.
  @HiveField(3)
  final List<OrderData> asks;

  @override
  OrderBookData fromJson(Map<String, dynamic> json) =>
      OrderBookData.fromJson(json);

  @override
  Map<String, dynamic> get toJson => <String, dynamic>{
        'bids': BaseModel.embeddedListToJson<OrderData>(bids),
        'asks': BaseModel.embeddedListToJson<OrderData>(asks),
      };

  @override
  String toString() => """
      Order Book Data:
      \nCreated on: ${createdAt.dm}""";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OrderBookData &&
        other.createdAt == createdAt &&
        other.id == id;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        createdAt.toIso8601String(),
        id,
      ]);

  static List<OrderData> _toDataBidList(dynamic data) =>
      (data as List<dynamic>).map((dynamic el) {
        final List<dynamic> list = el as List<dynamic>;
        return OrderData(
          price: _toDouble(list[0]),
          amount: _toDouble(list[1]),
          type: OrderDataTypes.bid,
        );
      }).toList();

  static List<OrderData> _toDataAskList(dynamic data) =>
      (data as List<dynamic>).map((dynamic el) {
        final List<dynamic> list = el as List<dynamic>;
        return OrderData(
          price: _toDouble(list[0]),
          amount: _toDouble(list[1]),
          type: OrderDataTypes.ask,
        );
      }).toList();

  static double _toDouble(dynamic data) {
    switch (data.runtimeType) {
      case int:
        return (data as int).toDouble();
      case double:
        return data as double;
      default:
        return 0;
    }
  }
}
