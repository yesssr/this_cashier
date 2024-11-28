import 'package:flutter/material.dart';

import '../constant.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.hintText,
    this.icon,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
  });
  final String hintText;
  final Icon? icon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: labelMedReg,
      controller: widget.controller,
      cursorColor: secondaryColor,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: textFieldStyle.copyWith(
        hintText: widget.hintText,
        prefixIcon: widget.icon ?? const Icon(Icons.search),
      ),
    );
  }
}
