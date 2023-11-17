import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final double? borderRadius;

  const RoundedButton({Key? key, required this.text,
    required this.width, required this.height,
    required this.color, required this.textColor,
    this.textStyle, this.border, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
          color: color,
          border: border
      ),
      child: Text(text,
          style: textStyle ?? TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700)
      ),
    );
  }
}
