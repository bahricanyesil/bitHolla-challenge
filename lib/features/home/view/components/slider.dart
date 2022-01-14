part of '../home_screen.dart';

class _Slider extends StatelessWidget {
  const _Slider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: context.topPadding(Sizes.lowMed),
        height: context.height * 7,
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
        Expanded(
          child: CustomizedSlider(
            values: HomeViewModel.sliderValues,
            sliderCallback: context.read<HomeViewModel>().sliderCallback,
          ),
        ),
      ];
}
