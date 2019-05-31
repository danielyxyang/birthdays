
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/ui/dialogs/createUpdateBirthdayDialog.dart';
import 'package:birthdays/src/ui/dialogs/confirmDialog.dart';
import 'package:flutter/material.dart';

Future<Birthday> showCreateBirthdayDialog(BuildContext context) async {
  return showUpdateBirthdayDialog(context, null);
}
Future<Birthday> showUpdateBirthdayDialog(BuildContext context, Birthday birthday) async {
  return showDialog<Birthday>(
    context: context,
    builder: (BuildContext context) {
      return CreateUpdateBirthdayDialog(birthday);
    },
  );
}
Future<bool> showConfirmDialog(BuildContext context, String text, String actionName) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDialog(text, actionName);
    },
  ) ?? false;
}
