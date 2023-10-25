import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final VoidCallback onClicked;
  final double? fontSize;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Widget? icon;

  const ButtonWidget({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.onClicked,
    this.fontSize,
    this.verticalPadding,
    this.horizontalPadding,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        shadowColor: Colors.grey.shade700,
        elevation: 5,
        shape: const StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? width / 8, vertical: verticalPadding ?? 12),
      ),
      onPressed: onClicked,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize ?? 20, color: foregroundColor, fontWeight: FontWeight.w600),
          ),
          if (icon != null) const SizedBox(width: 10),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
