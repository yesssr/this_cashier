import 'package:flutter/material.dart';

import '../constant.dart';

Widget otlBtn({
  required String nameField,
  required BuildContext context,
  required VoidCallback onPressed,
  bool? negActions = false,
  bool? border = true,
  bool? fixedMobileSize = false,
  bool? isResponsive = false,
}) {
  const Size size = Size(312, 40);
  return TextButton(
    onPressed: onPressed,
    style: border == true
        ? TextButton.styleFrom(
            fixedSize: fixedMobileSize == true
                ? size
                : isResponsive == true
                    ? Size(MediaQuery.of(context).size.width, 40)
                    : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 1,
                color: negActions == false ? secondaryColor : errorColor,
                style: BorderStyle.solid,
              ),
            ),
          )
        : TextButton.styleFrom(),
    child: Text(
      nameField,
      style: labelMedMed.copyWith(
        color: negActions == false ? secondaryColor : errorColor,
      ),
    ),
  );
}

Widget fillBtn({
  required String nameField,
  required BuildContext context,
  required VoidCallback onPressed,
  bool? negActions = false,
  bool? border = true,
  bool? fixedMobileSize = false,
  bool? isResponsive = false,
  Color? color,
}) {
  const Size size = Size(312, 40);
  return FilledButton(
    onPressed: onPressed,
    style: border == true
        ? FilledButton.styleFrom(
            backgroundColor:
                negActions == false ? color ?? secondaryColor : errorColor,
            fixedSize: fixedMobileSize == true
                ? size
                : isResponsive == true
                    ? Size(MediaQuery.of(context).size.width, 40)
                    : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 1,
                color:
                    negActions == false ? color ?? secondaryColor : errorColor,
                style: BorderStyle.solid,
              ),
            ),
          )
        : FilledButton.styleFrom(),
    child: Text(
      nameField,
      style: labelMedMed,
    ),
  );
}
