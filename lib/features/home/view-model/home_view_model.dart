import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../product/constants/enums/socket_connection_enums.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  /// [WebSocketChannel] to make a communication with the web server.
  late final WebSocketChannel channel;
  final Set<String> _subscribedTopics = <String>{};

  static const String _defaultTopic = 'orderbook:xht-usdt';

  /// Complete possible value list for the slider.
  static const List<double> sliderValues = <double>[0.0001, 0.001, 0.01, 0.1];

  @override
  FutureOr<void> init() async {
    channel =
        WebSocketChannel.connect(Uri.parse('wss://api.hollaex.com/stream'));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  /// Subscribes to the given topic.
  void subscribe([String topic = _defaultTopic]) {
    if (_subscribedTopics.contains(topic)) return;
    channel.sink.add(_subscriptionJson(SocketOps.subscribe, topic));
    _subscribedTopics.add(topic);
  }

  /// Unsubscribes from the given topic.
  void unsubscribe([String topic = _defaultTopic]) {
    if (!_subscribedTopics.contains(topic)) return;
    channel.sink.add(_subscriptionJson(SocketOps.unsubscribe, topic));
    _subscribedTopics.remove(topic);
  }

  String _subscriptionJson(SocketOps op, String topic) => jsonEncode(
        <String, dynamic>{
          "op": op.name,
          "args": <String>[topic]
        },
      );
}
