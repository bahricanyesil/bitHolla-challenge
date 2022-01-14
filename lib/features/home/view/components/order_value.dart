part of '../home_screen.dart';

class _OrderValue extends StatelessWidget with ListenHomeValue {
  const _OrderValue({
    required this.orderData,
    required this.index,
    required this.selectedColor,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  final OrderData orderData;
  final int index;
  final bool selected;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final _OrderValueModel model = _orderValue(context);
    return BaseText(
      index == 0
          ? model.value.thousandComma()
          : model.value.thousandComma(fraction: index),
      flatText: true,
      textAlign: model.textAlign,
      color: selected ? AppColors.white : model.textColor,
      fontSizeFactor: selected ? 6 : 5.3,
    );
  }

  _OrderValueModel _orderValue(BuildContext context) {
    num number = 0.0;
    TextAlign textAlign = TextAlign.end;
    Color textColor = AppColors.black.lighten();
    final HomeViewModel model = context.read<HomeViewModel>();
    final List<OrderData> list =
        orderData.type == OrderDataTypes.ask ? model.asks : model.bids;
    final bool isTotalAmount =
        listenValue(context, (HomeViewModel model) => model.isTotalAmount);
    final int orderIndex =
        list.indexWhere((OrderData el) => el.price == orderData.price);
    for (int i = orderIndex; i >= 0; i--) {
      number +=
          isTotalAmount ? list[i].amount : (list[i].price * list[i].amount);
    }

    switch (index) {
      case 0:
        number = orderData.price;
        textAlign = TextAlign.start;
        textColor = selectedColor.darken(.1);
        break;
      case 1:
        number = orderData.amount;
        textAlign = TextAlign.center;
        textColor = AppColors.black;
        break;
    }
    return _OrderValueModel(
      value: number.delDecimalZeros,
      textAlign: textAlign,
      textColor: textColor,
      selectedColor: selectedColor,
      type: orderData.type,
    );
  }
}

class _OrderValueModel {
  const _OrderValueModel({
    required this.value,
    required this.textAlign,
    required this.textColor,
    required this.selectedColor,
    required this.type,
  });

  final String value;
  final TextAlign textAlign;
  final Color textColor;
  final Color selectedColor;
  final OrderDataTypes type;
}
