import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/extensions/date/date_time_extensions.dart';
import '../../../../core/helpers/hasher.dart';
import '../../../core/base/model/base_model.dart';
import '../../managers/local-storage/hive_configs.dart';
import 'order_book_data.dart';

part 'order_book_response.g.dart';

@HiveType(typeId: HiveConfigs.orderBookResponse)

/// Stores the information about a orderBookResponse.
class OrderBookResponse
    with HiveObjectMixin
    implements BaseModel<OrderBookResponse> {
  /// Default constructor for [OrderBookResponse].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  OrderBookResponse({
    required this.topic,
    required this.action,
    required this.symbol,
    OrderBookData? data,
  })  : id = const Uuid().v4(),
        data = data ?? OrderBookData(),
        createdAt = DateTime.now();

  /// Mock object, dummy data for [OrderBookResponse].
  OrderBookResponse.mock({
    String? topic,
    String? action,
    String? symbol,
    OrderBookData? data,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now(),
        topic = topic ?? "orderbook",
        action = action ?? "partial",
        symbol = symbol ?? "xht-usdt",
        data = data ?? OrderBookData.mock();

  factory OrderBookResponse.fromJson(Map<String, dynamic> json) =>
      OrderBookResponse(
        action: BaseModel.getWithDefault<String>(json['action'], ''),
        topic: BaseModel.getWithDefault<String>(json['topic'], ''),
        symbol: BaseModel.getWithDefault<String>(json['symbol'], ''),
        data: BaseModel.embeddedModelFromJson<OrderBookData>(
            json['data'], OrderBookData()),
      );

  /// Unique id of the orderBookResponse.
  @HiveField(0)
  final String id;

  /// The date when the orderBookResponse is created.
  @HiveField(1)
  final DateTime createdAt;

  /// The topic of the orderBookResponse.
  @HiveField(2)
  String topic;

  /// The action type.
  @HiveField(3)
  String action;

  /// The symbol of the order book.
  @HiveField(4)
  String symbol;

  /// The data of the order book.
  @HiveField(5)
  OrderBookData data;

  @override
  OrderBookResponse fromJson(Map<String, dynamic> json) =>
      OrderBookResponse.fromJson(json);

  @override
  Map<String, dynamic> get toJson => <String, dynamic>{
        'action': action,
        'symbol': symbol,
        'topic': topic,
        'data': data.toJson,
      };

  @override
  String toString() => """
      Order Book Response Topic: $topic
      \nAction: $action
      \nSymbol: $symbol
      \nCreated on: ${createdAt.dm}""";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OrderBookResponse &&
        other.createdAt == createdAt &&
        other.topic == topic &&
        other.action == action &&
        other.symbol == symbol &&
        other.id == id;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        createdAt.toIso8601String(),
        topic,
        action,
        symbol,
        id,
      ]);
}
