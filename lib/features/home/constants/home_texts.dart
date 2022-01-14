import 'package:flutter/material.dart';

import '../view/home_screen.dart';

/// Collection of texts in the [HomeScreen].
mixin HomeTexts on Widget {
  /// Text key for the title of the screen.
  static const String title = 'order_book';

  /// Type of the visible market.
  static const String marketType = 'market_type';

  /// Title of the interval slider.
  static const String intervalTitle = 'interval_title';

  /// List of title texts for the table.
  static const List<String> tableTitles = <String>['price', 'amount', 'total'];

  /// List of subtitle texts for the table.
  static const List<String> tableSubtitles = <String>['USDT', 'XHT'];

  /// Text key for the sellers text.
  static const String sellers = 'sellers';

  /// Text key for the buyers text.
  static const String buyers = 'buyers';

  /// Text key for "spread".
  static const String spread = 'spread';
}
