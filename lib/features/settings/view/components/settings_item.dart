part of '../settings_screen.dart';

class _SettingsItem extends StatelessWidget
    with SettingsTexts, ListenSettingsValue {
  const _SettingsItem({required this.settings, Key? key}) : super(key: key);
  final SettingsOptions settings;

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          dense: true,
          child: _expansionTile(context),
        ),
      );

  Widget _expansionTile(BuildContext context) => ExpansionTile(
        collapsedTextColor: context.primaryLightColor,
        collapsedIconColor: context.primaryLightColor,
        tilePadding: EdgeInsets.symmetric(horizontal: context.width * 1.5),
        leading: PrimaryBaseIcon(settings.icon, sizeFactor: 9),
        title: _title(context),
        subtitle: _subtitle(context),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        children: _children(context),
      );

  List<Widget> _children(BuildContext context) {
    switch (settings) {
      case SettingsOptions.visibleTaskSections:
        return List<CustomCheckboxTile>.generate(
            10, (int i) => _checkbox(i, context));
      case SettingsOptions.info:
        return <Widget>[]; //_infoTexts(context);
    }
  }

  /*List<Widget> _infoTexts(BuildContext context) => List<Padding>.generate(
        SettingsTexts.infoSentences.keys.length,
        (int i) => Padding(
          padding: context.horizontalPadding(Sizes.lowMed),
          child: BulletColoredText(
            text: SettingsTexts.infoSentences.keys.elementAt(i),
            coloredTexts: SettingsTexts.infoSentences.values.elementAt(i),
          ),
        ),
      );*/

  CustomCheckboxTile _checkbox(int i, BuildContext context)
      /*final TaskStatus status = TaskStatus.values[i];
    final SettingsViewModel model = context.read<SettingsViewModel>();
    return CustomCheckboxTile(
      text: status.value,
      onTap: (bool value) => model.setSectionVisibility(status, value),
      initialValue: listenVisibleSection(context, status),
    );*/
      =>
      CustomCheckboxTile(onTap: (bool val) {}, text: "text");

  Widget _title(BuildContext context) => BaseText(
        settings.title,
        textAlign: TextAlign.start,
        style: TextStyles(context).bodyStyle(),
      );

  Widget _subtitle(BuildContext context) => BaseText(
        settings.subtitle,
        textAlign: TextAlign.start,
        style: TextStyles(context).subtitleTextStyle(),
      );
}