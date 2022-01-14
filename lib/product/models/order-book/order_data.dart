import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/extensions/date/date_time_extensions.dart';
import '../../../../core/helpers/hasher.dart';
import '../../../core/base/model/base_model.dart';
import '../../constants/enums/order_data_types.dart';
import '../../managers/local-storage/hive_configs.dart';

part 'order_data.g.dart';

@HiveType(typeId: HiveConfigs.orderData)

/// [OrderData] model is to store the information about a orderData.
class OrderData with HiveObjectMixin implements BaseModel<OrderData> {
  /// Default constructor for [OrderData].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  OrderData({
    required this.type,
    this.price = 0,
    this.amount = 0,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now();

  /// Mock object, dummy data for [OrderData].
  OrderData.mock({
    double? price,
    double? amount,
    OrderDataTypes? type,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now(),
        price = price ?? Random().nextDouble(),
        type = type ?? OrderDataTypes.bid,
        amount = amount ?? Random().nextDouble() * 100;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
      amount: json['amount'], price: json['price'], type: OrderDataTypes.bid);

  /// Unique id of the orderData.
  @HiveField(0)
  final String id;

  /// The date when the orderData is created.
  @HiveField(1)
  final DateTime createdAt;

  /// The price of the ask.
  @HiveField(2)
  final double price;

  /// The amount of the ask.
  @HiveField(3)
  double amount;

  /// The type of the order.
  @HiveField(4)
  OrderDataTypes type;

  @override
  OrderData fromJson(Map<String, dynamic> json) => OrderData.fromJson(json);

  @override
  Map<String, dynamic> get toJson =>
      <String, dynamic>{'amount': amount, 'price': price};

  @override
  String toString() => """
      Order Data:
      Price = $price
      Amount = $amount
      Type = $type
      \nCreated on: ${createdAt.dm}""";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OrderData &&
        other.createdAt == createdAt &&
        other.id == id &&
        price == other.price &&
        amount == other.amount;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        createdAt.toIso8601String(),
        id,
        price.toString(),
        amount.toString(),
      ]);
}
