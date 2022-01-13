import 'package:bitholla_challenge/core/constants/enums/view-enums/sizes.dart';
import 'package:bitholla_challenge/core/widgets/divider/custom_divider.dart';
import 'package:bitholla_challenge/core/widgets/text/lined-text/lined_text.dart';
import 'package:flutter/material.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/context/language_helpers.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/app-bar/default_app_bar.dart';
import '../../../core/widgets/slider/customized_slider.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../constants/home_texts.dart';
import '../utilities/listen_home_value.dart';
import '../view-model/home_view_model.dart';

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
          textStyle: TextStyles(context).normalStyle(color: AppColors.white),
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
          horizontal: context.medWidth,
          vertical: context.lowHeight,
        ),
        child: _bodyColumn(context),
      );

  Widget _bodyColumn(BuildContext context) => Column(
        children: <Widget>[
          _slider(context),
          _tableTitles(context),
          const CustomDivider(),
          SizedBox(height: context.height * .4),
          _linedText(context, HomeTexts.sellers, AppColors.error),
          _linedText(context, HomeTexts.buyers, AppColors.green),
        ],
      );

  Widget _linedText(BuildContext context, String textKey, Color color) =>
      LinedText(text: context.tr(textKey), lineColor: color);

  Widget _tableTitles(BuildContext context) => Row(
        children:
            List<Widget>.generate(HomeTexts.tableTitles.length, _tableTitle),
      );

  Widget _tableTitle(int i) => Expanded(
        child: Column(
          children: <Widget>[
            BaseText(HomeTexts.tableTitles[i], fontSizeFactor: 5.5),
            BaseText(HomeTexts.tableSubtitles[i],
                fontSizeFactor: 3.8, flatText: true),
          ],
        ),
      );

  Widget _slider(BuildContext context) => Container(
        margin: context.topPadding(Sizes.lowMed),
        height: context.height * 6,
        child: Row(children: _sliderRowElements(context)),
      );

  List<Widget> _sliderRowElements(BuildContext context) => <Widget>[
        BaseText(
          '${context.tr(HomeTexts.intervalTitle)}:',
          style:
              TextStyles(context).subBodyStyle(color: context.primaryDarkColor),
          flatText: true,
        ),
        SizedBox(width: context.width * .6),
        const Expanded(
            child: CustomizedSlider(values: HomeViewModel.sliderValues)),
      ];

  Widget _streamBuilder(HomeViewModel model) => StreamBuilder<dynamic>(
        stream: model.channel.stream,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          final List<Widget> children = <Widget>[];
          switch (snapshot.data) {
            case null:
              children
                  .add(const Expanded(child: LoadingIndicator(sizeFactor: 30)));
              break;
            default:
              children.add(
                SizedBox(
                  height: 300,
                  child: Text(
                    snapshot.data,
                    style: const TextStyle(color: AppColors.black),
                  ),
                ),
              );
          }
          return Center(
            child: Column(
              children: <Widget>[
                ...children,
                TextButton(
                    onPressed: model.subscribe, child: const Text('Subscribe')),
                TextButton(
                    onPressed: model.unsubscribe,
                    child: const Text('UNSubscribe')),
              ],
            ),
          );
        },
      );
}
