import 'package:flutter/material.dart';

import '../extension/color_extension.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isWarning;

  const CustomAlertDialog(
      {required this.title, required this.message, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(title),
          SizedBox(width: 10),
          isWarning
              ? Icon(Icons.warning_amber, color: Colors.red)
              : SizedBox.fromSize(),
        ],
      ),
      content: Text(message),
      actions: [
        !isWarning
            ? TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Add your logic here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Text('NO', style: TextStyle(color: Colors.white)),
              )
            : SizedBox.shrink(),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                isWarning ? Colors.red : AppColors.contentColorBlue),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}
