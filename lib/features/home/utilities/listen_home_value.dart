import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../product/models/order-book/order_data.dart';
import '../view-model/home_view_model.dart';

/// A utility to listen a specific value in [HomeViewModel].
mixin ListenHomeValue {
  /// Listens a specific value.
  T listenValue<T>(
          BuildContext context, T Function(HomeViewModel model) func) =>
      context.select<HomeViewModel, T>(func);

  /// Returns the list of bids.
  List<OrderData> listenBids(BuildContext context) =>
      context.select<HomeViewModel, List<OrderData>>(
          (HomeViewModel model) => model.bids);

  /// Returns the list of asks.
  List<OrderData> listenAsks(BuildContext context) =>
      context.select<HomeViewModel, List<OrderData>>(
          (HomeViewModel model) => model.asks);
}
