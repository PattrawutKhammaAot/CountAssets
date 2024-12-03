import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.color,
    this.onPressed,
    this.text,
    this.icon,
    this.isUseIcon = true,
  });
  Function()? onPressed;
  String? text;
  Color? color;
  IconData? icon;
  bool isUseIcon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isUseIcon
              ? Icon(
                  icon,
                  color: Colors.white,
                )
              : SizedBox.fromSize(),
          isUseIcon
              ? SizedBox(
                  width: 5,
                )
              : SizedBox.fromSize(),
          Text(
            "${text!}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
