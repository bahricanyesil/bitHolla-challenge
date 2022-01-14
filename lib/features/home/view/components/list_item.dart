part of '../home_screen.dart';

class _ListItem extends StatefulWidget {
  const _ListItem({
    required this.data,
    required this.selectedColor,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);
  final OrderData data;
  final bool isSelected;
  final Color selectedColor;

  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  bool isHovering = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    selected = widget.isSelected || isHovering;
    return kIsWeb
        ? MouseRegion(
            onEnter: _onHover,
            onExit: _onExitHover,
            child: _decoratedItemWrapper,
          )
        : Listener(
            onPointerDown: _onHover,
            onPointerUp: _onExitHover,
            child: _decoratedItemWrapper,
          );
  }

  Widget get _decoratedItemWrapper {
    final double ratio = _colorRatio(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: <Color>[_color, AppColors.white],
          stops: selected ? <double>[1, 0] : <double>[ratio, 1 + ratio],
        ),
      ),
      child: Padding(
        padding: context.horizontalPadding(Sizes.low),
        child: Row(children: List<Widget>.generate(3, _item)),
      ),
    );
  }

  double _colorRatio(BuildContext context) {
    final HomeViewModel model = context.read<HomeViewModel>();
    final double total = widget.data.type == OrderDataTypes.bid
        ? model.totalBid
        : model.totalAsk;
    return widget.data.amount / total;
  }

  Color get _color => widget.selectedColor.lighten(
      selected ? .08 : (widget.data.type == OrderDataTypes.ask ? 0.12 : 0.08));

  Widget _item(int k) => Expanded(
        child: _OrderValue(
          orderData: widget.data,
          index: k,
          selected: selected,
          selectedColor: widget.selectedColor,
        ),
      );

  void _onHover(_) => setState(() => isHovering = true);
  void _onExitHover(_) => setState(() => isHovering = false);
}
