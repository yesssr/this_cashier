import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class CustomActiveText extends StatelessWidget {
  const CustomActiveText({
    super.key,
    required this.activeText,
    this.onActiveTextClick,
    required this.passiveText,
    this.color,
    this.fontWeight,
  });

  final String passiveText;
  final String activeText;
  final VoidCallback? onActiveTextClick;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: passiveText,
        style: labelMedMed.copyWith(color: Colors.black),
        children: [
          TextSpan(
            text: activeText,
            style: labelMedMed.copyWith(color: color ?? secondaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = onActiveTextClick ?? () {},
          )
        ],
      ),
    );
  }
}
