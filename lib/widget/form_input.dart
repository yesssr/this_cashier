import 'package:flutter/material.dart';
import 'package:this_cashier/constant.dart';

class FormInputWidget extends StatefulWidget {
  const FormInputWidget({
    super.key,
    required this.nameField,
    this.fieldController,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.hint,
    this.value,
    this.validator,
    this.disposed = true,
    this.isResponsive = false,
  });

  final TextEditingController? fieldController;
  final String nameField;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool? enabled;
  final String? hint;
  final String? value;
  final bool? disposed;
  final bool? isResponsive;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  @override
  void dispose() {
    super.dispose();
    if (widget.disposed == true) {
      widget.fieldController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: fixedMobileSize,
          child: Text(
            widget.nameField,
            style: labelMedBold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: labelMedReg,
          initialValue: widget.value,
          enabled: widget.enabled,
          cursorColor: secondaryColor,
          maxLines: widget.maxLines,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          validator: widget.validator ??
              (value) =>
                  value!.isEmpty ? "${widget.nameField} diperlukan!." : null,
          controller: widget.fieldController,
          keyboardType: widget.keyboardType,
          decoration: textFieldStyle.copyWith(
            constraints: widget.isResponsive == true
                ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width)
                : fixedMobileSize,
            hintText: widget.hint ?? widget.nameField,
            errorStyle: labelMedReg.copyWith(color: errorColor),
          ),
        ),
      ],
    );
  }
}
