import 'package:ams_express/extension/color_extension.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton2 extends StatelessWidget {
  const CustomDropdownButton2(
      {super.key,
      this.readOnly,
      this.items,
      this.selectedValue,
      this.onChanged,
      this.labelText,
      this.hintText,
      this.focusNode,
      this.value,
      this.validator});

  final List<DropdownMenuItem<dynamic>>? items;
  final String? selectedValue;
  final Function(dynamic?)? onChanged;
  final String? labelText;
  final String? hintText;
  final FocusNode? focusNode;
  final dynamic value;
  final String? Function(dynamic)? validator;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<dynamic>(
      isExpanded: true,
      focusNode: focusNode,
      value: value,
      autofocus: true,

      decoration: InputDecoration(
        enabled: false,
        hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),

        errorStyle: TextStyle(color: Colors.red),
        hintText: hintText,
        filled: true,
        focusColor: Colors.red,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black45), // หรือสีของกรอบเมื่อไม่มีการโฟกัส
          borderRadius: BorderRadius.circular(6),
        ),
        fillColor: Colors.white,
        labelStyle: TextStyle(color: AppColors.contentColorBlue),
        labelText: labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        // Add more decoration..
      ),
      // hint: const Text(
      //   'Select Status',
      //   style: TextStyle(
      //       fontSize: 14, color: colorPrimary, fontWeight: FontWeight.bold),
      // ),
      items: items,
      validator: validator,
      onChanged: onChanged,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
