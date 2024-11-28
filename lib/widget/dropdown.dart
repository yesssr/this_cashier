import 'package:flutter/material.dart';

import '../constant.dart';

class MyDropdown extends StatelessWidget {
  const MyDropdown({
    super.key,
    required this.nameField,
    required this.items,
    required this.onChanged,
    this.initValue,
    this.hintText,
  });

  final String nameField;
  final String? hintText;
  final List<DropdownMenuItem> items;
  final dynamic initValue;
  final void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: fixedMobileSize,
          child: Text(
            nameField,
            style: labelMedBold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<dynamic>(
          style: labelMedReg.copyWith(color: Colors.black),
          hint: Text(hintText ?? nameField),
          value: initValue,
          decoration: InputDecoration(
            errorStyle: labelMedReg.copyWith(color: errorColor),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: secondaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
          ),
          validator: (value) =>
              value == null ? "$nameField diperlukan!." : null,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
