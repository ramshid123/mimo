import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mimo/core/theme/palette.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final IconData checkedIcon;
  final Color uncheckedIconColor;
  final Color uncheckedFillColor;
  final IconData uncheckedIcon;
  final double? borderWidth;
  final double? checkBoxSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = ColorConstants.green,
    this.checkedIcon = Icons.check,
    this.uncheckedIconColor = Colors.white,
    this.uncheckedFillColor = Colors.white,
    this.uncheckedIcon = Icons.close,
    this.borderWidth,
    this.checkBoxSize,
    this.shouldShowBorder = false,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor,
    this.tooltip,
    this.mouseCursors,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _checked;
  late CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    late Color fillColor;
    late Color iconColor;
    late IconData iconData;

    switch (_status) {
      case CheckStatus.checked:
        fillColor = widget.checkedFillColor;
        iconColor = widget.checkedIconColor;
        iconData = widget.checkedIcon;
        break;
      case CheckStatus.unchecked:
        fillColor = widget.uncheckedFillColor;
        iconColor = widget.uncheckedIconColor;
        iconData = widget.uncheckedIcon;
        break;
    }

    return DottedBorder(
      borderType: BorderType.Circle,
      dashPattern: [4, 0, 0],
      strokeCap: StrokeCap.round,
      strokeWidth: 3,
      padding: EdgeInsets.zero,
      color: _status == CheckStatus.checked
          ? Colors.transparent
          : ColorConstants.green,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          // border: Border.all(
          //   color: widget.shouldShowBorder
          //       ? (widget.borderColor ?? ColorConstants.green.withOpacity(0.6))
          //       : Colors.transparent,
          //   // (!widget.value
          //   //     ? (widget.borderColor ??
          //   //         ColorConstants.green.withOpacity(0.6))
          //   //     : Colors.transparent),
          //   width: widget.shouldShowBorder ? widget.borderWidth ?? 2.0 : 1.0,
          // ),
        ),
        child: Padding(
          padding: EdgeInsets.all(_status == CheckStatus.checked ? 6 : 4),
          child: Icon(
            iconData,
            color: iconColor,
            size: widget.checkBoxSize ?? 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _buildIcon(),
      onPressed: () => widget.onChanged(!_checked),
      splashRadius: widget.splashRadius,
      splashColor: widget.splashColor,
      tooltip: widget.tooltip,
      mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
    );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
