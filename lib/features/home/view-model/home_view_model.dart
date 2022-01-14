import 'dart:async';
import 'dart:convert';

import 'package:bitholla_challenge/features/home/constants/home_texts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/constants/enums/socket_connection_enums.dart';
import '../../../product/models/order-book/order_book_response.dart';
import '../../../product/models/order-book/order_data.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  /// [WebSocketChannel] to make a communication with the web server.
  late final WebSocketChannel channel;

  /// [WebSocketChannel] to make a communication with the web server for trade.
  late final WebSocketChannel tradeChannel;
  final Set<String> _subscribedTopics = <String>{};

  static const String _defaultTopicOrderbook = 'orderbook:xht-usdt';
  static const String _defaultTopicTrade = 'trade:xht-usdt';

  /// Complete possible value list for the slider.
  static const List<double> sliderValues = <double>[0.0001, 0.001, 0.01, 0.1];

  List<OrderData> _bids = <OrderData>[];
  List<OrderData> _asks = <OrderData>[];

  /// Filtered bids.
  List<OrderData> bids = <OrderData>[];

  /// Filtered asks.
  List<OrderData> asks = <OrderData>[];

  /// Index of the slider.
  int sliderIndex = 0;

  /// Indicates whether the selected filter is the amount for the total.
  bool isTotalAmount = true;

  @override
  FutureOr<void> init() async {
    channel =
        WebSocketChannel.connect(Uri.parse('wss://api.hollaex.com/stream'));
    tradeChannel =
        WebSocketChannel.connect(Uri.parse('wss://api.hollaex.com/stream'));
    subscribe();
  }

  @override
  void dispose() {
    channel.sink.close();
    tradeChannel.sink.close();
    super.dispose();
  }

  /// Subscribes to the given topic.
  void subscribe([String topic = _defaultTopicOrderbook]) {
    if (_subscribedTopics.contains(topic)) return;
    channel.sink.add(_subscriptionJson(SocketOps.subscribe, topic));
    tradeChannel.sink
        .add(_subscriptionJson(SocketOps.subscribe, _defaultTopicTrade));
    _subscribedTopics.add(topic);
  }

  /// Unsubscribes from the given topic.
  void unsubscribe([String topic = _defaultTopicOrderbook]) {
    if (!_subscribedTopics.contains(topic)) return;
    channel.sink.add(_subscriptionJson(SocketOps.unsubscribe, topic));
    tradeChannel.sink
        .add(_subscriptionJson(SocketOps.unsubscribe, _defaultTopicTrade));
    _subscribedTopics.remove(topic);
  }

  String _subscriptionJson(SocketOps op, String topic) => jsonEncode(
        <String, dynamic>{
          "op": op.name,
          "args": <String>[topic]
        },
      );

  /// Callback of the slider.
  void sliderCallback(double? value) {
    if (value != null) {
      sliderIndex = value.toInt();
      _filterBidsAndAsks();
      notifyListeners();
    }
  }

  /// Fills the local bids and asks lists.
  void setLists(Map<String, dynamic> json) {
    final OrderBookResponse response = OrderBookResponse.fromJson(json);
    _bids = response.data.bids;
    _asks = response.data.asks;
    _filterBidsAndAsks();
  }

  List<OrderData> _filterList(List<OrderData> list) {
    final List<OrderData> filteredList = <OrderData>[];
    for (int i = 0; i < list.length; i++) {
      final double price = _fixedPrice(list[i]);
      final int index =
          filteredList.indexWhere((OrderData el) => _fixedPrice(el) == price);
      if (index == -1) {
        filteredList.add(OrderData(
            price: price, amount: list[i].amount, type: list[i].type));
      } else {
        filteredList[index].amount += list[i].amount;
      }
    }
    return filteredList;
  }

  void _filterBidsAndAsks() {
    bids = _filterList(_bids);
    asks = _filterList(_asks);
  }

  double _fixedPrice(OrderData data) =>
      double.parse(data.price.toStringAsFixed(4 - sliderIndex));

  /// Total bid amount.
  double get totalBid {
    double sum = 0;
    for (final OrderData el in bids) {
      sum += el.amount;
    }
    return sum;
  }

  /// Total ask amount.
  double get totalAsk {
    double sum = 0;
    for (final OrderData el in asks) {
      sum += el.amount;
    }
    return sum;
  }

  /// Sets the filter type for total.
  void setTotal(String choice) {
    if (choice == HomeTexts.tableSubtitles[0] && isTotalAmount) {
      isTotalAmount = false;
      notifyListeners();
    } else if (choice == HomeTexts.tableSubtitles[1] && !isTotalAmount) {
      isTotalAmount = true;
      notifyListeners();
    }
  }
}
