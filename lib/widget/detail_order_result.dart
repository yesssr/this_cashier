import 'package:flutter/material.dart';

import '../constant.dart';

class DetailOrderResult extends StatelessWidget {
  const DetailOrderResult({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: labelLargeMed,
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: labelMedReg.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade400),
        const SizedBox(height: 8),
      ],
    );
  }
}
