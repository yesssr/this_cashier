import 'package:flutter/material.dart';

import '../constant.dart';

class FormPasswordWidget extends StatefulWidget {
  const FormPasswordWidget({
    super.key,
    required this.passwordController,
    this.nameField = "Password",
    this.hint,
    this.validator,
  });

  final TextEditingController passwordController;
  final String nameField;
  final String? hint;
  final String? Function(String?)? validator;

  @override
  State<FormPasswordWidget> createState() => _FormPasswordWidgetState();
}

class _FormPasswordWidgetState extends State<FormPasswordWidget> {
  bool hidePass = true;

  @override
  void dispose() {
    super.dispose();
    widget.passwordController.dispose();
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
          cursorColor: secondaryColor,
          style: labelMedReg,
          validator: widget.validator ??
              (value) => value!.isEmpty ? "Password diperlukan!." : null,
          controller: widget.passwordController,
          obscureText: hidePass,
          keyboardType: TextInputType.visiblePassword,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: textFieldStyle.copyWith(
            errorStyle: labelMedReg.copyWith(color: errorColor),
            constraints: fixedMobileSize,
            hintText: widget.hint ?? widget.nameField,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePass = !hidePass;
                });
              },
              icon: hidePass == true
                  ? const Icon(Icons.remove_red_eye)
                  : const Icon(Icons.remove_red_eye_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
