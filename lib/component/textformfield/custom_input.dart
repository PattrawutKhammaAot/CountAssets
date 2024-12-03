import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  Custominput({
    super.key,
    this.focusNode,
    this.labelText,
    this.onSubmitted,
    this.onEditingComplete,
    this.controller,
    this.readOnly,
    this.suffix,
    this.hintText,
  });

  TextEditingController? controller;
  String? labelText;
  Function(String)? onSubmitted;
  Function()? onEditingComplete;
  FocusNode? focusNode;
  bool? readOnly;
  Widget? suffix;
  String? hintText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        readOnly: readOnly ?? false,
        enabled: readOnly != null
            ? readOnly!
                ? false
                : true
            : true,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffix,
          hintText: hintText,
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
