import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/order_data_types.dart';
import '../../../product/models/order-book/order_book_shelf.dart';
import '../constants/home_texts.dart';
import '../utilities/listen_home_value.dart';
import '../view-model/home_view_model.dart';

part 'components/list_item.dart';
part 'components/middle_row.dart';
part 'components/order_value.dart';
part 'components/slider.dart';
part 'components/table_titles.dart';

/// Home Screen of the app.
class HomeScreen extends StatelessWidget with HomeTexts, ListenHomeValue {
  /// Default constructor for home screen.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleIcon: Icons.auto_graph_outlined,
          titleText: HomeTexts.title,
          actionsList: _appBarActions(context),
          textStyle: TextStyles(context).titleStyle(color: AppColors.white),
        ),
      );

  List<Widget> _appBarActions(BuildContext context) => <Widget>[
        BaseText(HomeTexts.marketType,
            style: TextStyles(context).subBodyStyle(color: AppColors.white)),
        IconButton(
          onPressed: () => NavigationManager.instance
              .setNewRoutePath(ScreenConfig.settings()),
          icon: const BaseIcon(Icons.settings_outlined),
          splashRadius: 22,
        )
      ];

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.medWidth, vertical: context.lowHeight),
        child: _bodyColumn(context),
      );

  Widget _bodyColumn(BuildContext context) => Column(
        children: <Widget>[
          const _Slider(),
          const _TableTitles(),
          const CustomDivider(),
          SizedBox(height: context.height * .6),
          LinedText(
              text: context.tr(HomeTexts.sellers), lineColor: AppColors.error),
          _streamBuilder(context.read<HomeViewModel>()),
          LinedText(
              text: context.tr(HomeTexts.buyers), lineColor: AppColors.green),
        ],
      );

  Widget _streamBuilder(HomeViewModel model) => StreamBuilder<dynamic>(
        stream: model.channel.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final Map<String, dynamic> json = _jsonizedData(snapshot.data);
          final List<Widget> children = _dataBody(context, json);
          return children.length > 1
              ? Expanded(child: _body(context, children))
              : _body(context, children);
        },
      );

  Widget _body(BuildContext context, List<Widget> children) => Container(
        margin: context.verticalPadding(Sizes.low),
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[...children]),
      );

  List<Widget> _dataBody(BuildContext context, Map<String, dynamic> json) {
    if (json['data'] != null) {
      context.read<HomeViewModel>().setLists(json);
      final List<OrderData> bids = listenBids(context);
      final List<OrderData> asks = listenAsks(context);
      double difference = 0;
      if (bids.isNotEmpty && asks.isNotEmpty) {
        difference = asks[0].price - bids[0].price;
      }
      return <Widget>[
        Expanded(child: _valueList(asks, isReverse: true)),
        _MiddleRow(difference: difference),
        Expanded(child: _valueList(bids)),
      ];
    }
    return <Widget>[const LoadingIndicator(sizeFactor: 30)];
  }

  Map<String, dynamic> _jsonizedData(String? data) {
    try {
      return jsonDecode(data ?? '');
    } on Exception catch (_) {
      return <String, dynamic>{};
    }
  }

  Widget _valueList(List<OrderData> list, {bool isReverse = false}) =>
      ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        reverse: isReverse,
        itemBuilder: (_, int i) => _ListItem(
          data: list[i],
          selectedColor:
              isReverse ? AppColors.error : AppColors.green.darken(.04),
          isSelected: i == 0,
        ),
      );
}
