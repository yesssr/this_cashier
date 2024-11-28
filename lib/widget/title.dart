import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class TitleAndDate extends StatelessWidget {
  const TitleAndDate({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bodyLargeBold.copyWith(color: secondaryColor),
        ),
        Text(
          DateFormat.yMMMMEEEEd().format(
            DateTime.now().toLocal(),
          ),
          style: labelLargeMed,
        ),
      ],
    );
  }
}
