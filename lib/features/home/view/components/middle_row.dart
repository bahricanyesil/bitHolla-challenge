part of '../home_screen.dart';

class _MiddleRow extends StatelessWidget {
  const _MiddleRow({required this.difference, Key? key}) : super(key: key);
  final double difference;

  @override
  Widget build(BuildContext context) => Container(
        height: context.height * 6.6,
        margin: context.horizontalPadding(Sizes.lowMed),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_lastTrade(context), _spread(context, difference)],
        ),
      );

  Widget _lastTrade(BuildContext context) => StreamBuilder<dynamic>(
      stream: context.read<HomeViewModel>().tradeChannel.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        try {
          final Map<String, dynamic> json = jsonDecode(snapshot.data ?? '');
          if (json['topic'] != null) {
            final double value = ((json['data'] as List<dynamic>)[0]
                as Map<String, dynamic>)['price'];
            return BaseText(
              value.delDecimalZeros,
              flatText: true,
              fontWeight: FontWeight.bold,
              fontSizeFactor: 7,
            );
          }
          return const LoadingIndicator(sizeFactor: 8);
        } on Exception catch (_) {
          return const LoadingIndicator(sizeFactor: 8);
        }
      });

  Widget _spread(BuildContext context, double diff) => RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '${context.tr(HomeTexts.spread)} ',
              style: TextStyles(context)
                  .subBodyStyle(color: AppColors.darkGrey.darken()),
            ),
            TextSpan(
                text: diff.delDecimalZeros,
                style: TextStyles(context).bodyStyle()),
          ],
        ),
      );
}
