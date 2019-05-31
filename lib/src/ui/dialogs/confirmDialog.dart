

import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog(this.text, this.actionName);
  final String text;
  final String actionName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 5),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(actionName),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

}