import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final int maxLines;
  final TextStyle? style;
  final Alignment alignment;

  const ResponsiveText({
    required this.text,
    this.alignment = Alignment.topLeft,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
    this.color = Colors.black,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: alignment,
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: style ??
            TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
        overflow: overflow,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}
