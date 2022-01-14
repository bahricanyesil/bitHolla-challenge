part of '../home_screen.dart';

class _TableTitles extends StatelessWidget with ListenHomeValue {
  const _TableTitles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: List<Widget>.generate(
            HomeTexts.tableTitles.length, (int i) => _tableTitle(context, i)),
      );

  Widget _tableTitle(BuildContext context, int i) => Expanded(
        child: Padding(
          padding: context.horizontalPadding(Sizes.low),
          child: Column(
            crossAxisAlignment: _alignment(i),
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(right: i == 2 ? context.width * 2.2 : 0),
                child: BaseText(HomeTexts.tableTitles[i],
                    fontSizeFactor: 5.5, fontWeight: FontWeight.w600),
              ),
              _lastSubtitle(context, i),
            ],
          ),
        ),
      );

  Widget _lastSubtitle(BuildContext context, int i) {
    if (i == 2) {
      return _popMenu(context);
    }
    return BaseText('(${HomeTexts.tableSubtitles[i]})',
        fontSizeFactor: 3.8, flatText: true);
  }

  Widget _popMenu(BuildContext context) => Theme(
        data: Theme.of(context)
            .copyWith(cardColor: AppColors.primaryColor.withOpacity(.9)),
        child: PopupMenuButton<String>(
          onSelected: (String? val) {},
          padding: EdgeInsets.zero,
          elevation: 6,
          child: _popMenuChild(context),
          itemBuilder: (BuildContext context) => HomeTexts.tableSubtitles
              .map((String choice) => _popMenuItem(choice, context))
              .toList(),
        ),
      );

  PopupMenuItem<String> _popMenuItem(String choice, BuildContext context) =>
      PopupMenuItem<String>(
        value: choice,
        height: context.height * 4,
        onTap: () => context.read<HomeViewModel>().setTotal(choice),
        child: BaseText(choice,
            flatText: true, fontSizeFactor: 5, color: AppColors.white),
      );

  Widget _popMenuChild(BuildContext context) => Row(
        children: <Widget>[const Spacer(), _totalType(context), _dropDownIcon],
      );

  Widget get _dropDownIcon => const BaseIcon(
        Icons.arrow_drop_down_outlined,
        color: AppColors.black,
        sizeFactor: 7,
        padding: EdgeInsets.zero,
      );

  Widget _totalType(BuildContext context) {
    final bool isTotalAmount =
        listenValue(context, (HomeViewModel model) => model.isTotalAmount);
    return BaseText(
      isTotalAmount ? HomeTexts.tableSubtitles[1] : HomeTexts.tableSubtitles[0],
      fontSizeFactor: 3.8,
      flatText: true,
    );
  }

  CrossAxisAlignment _alignment(int i) {
    switch (i) {
      case 0:
        return CrossAxisAlignment.start;
      case 1:
        return CrossAxisAlignment.center;
      default:
        return CrossAxisAlignment.end;
    }
  }
}
