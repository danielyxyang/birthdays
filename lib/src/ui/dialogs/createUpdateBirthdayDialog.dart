
import 'package:birthdays/src/models/date.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateUpdateBirthdayDialog extends StatefulWidget {
  CreateUpdateBirthdayDialog(this.birthday);
  final Birthday birthday;

  @override
  _CreateUpdateBirthdayDialogState createState() => _CreateUpdateBirthdayDialogState();
}

class _CreateUpdateBirthdayDialogState extends State<CreateUpdateBirthdayDialog> {
  final FocusNode textFieldFocusNodeDay = FocusNode();
  final FocusNode textFieldFocusNodeMonth = FocusNode();
  final FocusNode textFieldFocusNodeYear = FocusNode();
  final TextEditingController textFieldControllerName = TextEditingController();
  final TextEditingController textFieldControllerDay = TextEditingController();
  final TextEditingController textFieldControllerMonth = TextEditingController();
  final TextEditingController textFieldControllerYear = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.birthday != null) {
      NumberFormat format = NumberFormat("00");
      textFieldControllerName.text = widget.birthday.name;
      textFieldControllerDay.text = format.format(widget.birthday.date.day);
      textFieldControllerMonth.text = format.format(widget.birthday.date.month);
      textFieldControllerYear.text = widget.birthday.date.year != Birthday.UNDEFINED_YEAR ? widget.birthday.date.year.toString() : "";
    }
  }

  @override
  void dispose() {
    textFieldFocusNodeDay.dispose();
    textFieldFocusNodeMonth.dispose();
    textFieldFocusNodeYear.dispose();
    textFieldControllerName.dispose();
    textFieldControllerDay.dispose();
    textFieldControllerMonth.dispose();
    textFieldControllerYear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.birthday != null ? 'Geburtstag bearbeiten' : 'Neuer Geburtstag'),
      contentPadding: EdgeInsets.fromLTRB(24, 10, 24, 5),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person, size: 32),
              title: _buildInputFieldName(),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.today, size: 32),
              title: _buildInputFieldDate(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text('Abbrechen'),
        ),
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) Navigator.pop(context, getBirthday());
          },
          child: Text('Speichern'),
        ),
      ],
    );
  }

  Widget _buildInputFieldName() {
    return TextFormField(
      controller: textFieldControllerName,
      autofocus: true,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        isDense: true,
        hintText: "Name",
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).requestFocus(textFieldFocusNodeDay),
      validator: (String value) => value.isEmpty ? "Bitte gib einen Namen ein." : null,
    );
  }

  Widget _buildInputFieldDate() {
    return FormField<List<String>>(
      initialValue: [textFieldControllerDay.text, textFieldControllerMonth.text, textFieldControllerYear.text],
      builder: (FormFieldState<List<String>> state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _NumberTextField(
                controller: textFieldControllerDay,
                focusNode: textFieldFocusNodeDay,
                nextFocusNode: textFieldFocusNodeMonth,
                numberCount: 2,
                hintText: "DD",
                hasError: state.hasError,
                autoEditComplete: true,
                onChange: (String value) {
                  state.value[0] = value;
                  state.didChange(state.value);
                },
              ),
              _NumberTextField(
                controller: textFieldControllerMonth,
                focusNode: textFieldFocusNodeMonth,
                nextFocusNode: textFieldFocusNodeYear,
                numberCount: 2,
                hintText: "MM",
                hasError: state.hasError,
                autoEditComplete: true,
                onChange: (String value) {
                  state.value[1] = value;
                  state.didChange(state.value);
                },
              ),
              _NumberTextField(
                controller: textFieldControllerYear,
                focusNode: textFieldFocusNodeYear,
                numberCount: 4,
                hintText: "YYYY",
                hasError: state.hasError,
                onChange: (String value) {
                  state.value[2] = value;
                  state.didChange(state.value);
                },
              ),
            ],
          ),
          state.hasError ? Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              state.errorText,
              style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).errorColor),
            ),
          ) : Container(),
        ],
      ),
      validator: (List<String> value) {
        if (value[0].isEmpty || value[1].isEmpty)
          return "Bitte gib ein gültiges Datum ein.";
        else {
          int year = value[2].isNotEmpty ? int.parse(value[2]) : Birthday.UNDEFINED_YEAR;
          int month = int.parse(value[1]);
          int day = int.parse(value[0]);
          Date birthdayDate = Date(year, month, day);
          if (birthdayDate.day != day || birthdayDate.month != month)
            return "Bitte gib ein gültiges Datum ein!";
        }
      },
    );
  }

  Birthday getBirthday() {
    String name = textFieldControllerName.text;
    int year = textFieldControllerYear.text.isNotEmpty ? int.parse(textFieldControllerYear.text) : Birthday.UNDEFINED_YEAR;
    int month = int.parse(textFieldControllerMonth.text);
    int day = int.parse(textFieldControllerDay.text);
    if (widget.birthday == null)
      return Birthday(name, Date(year, month, day));
    else {
      widget.birthday.name = name;
      widget.birthday.date = Date(year, month, day);
      return widget.birthday;
    }
  }
}

class _NumberTextField extends StatelessWidget {
  _NumberTextField({this.controller, this.focusNode, this.nextFocusNode, this.numberCount, this.hintText, this.hasError, this.autoEditComplete=false, this.onChange}) {
    focusNode.addListener(() {
      if (focusNode.hasFocus)
        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    });
  }
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final int numberCount;
  final String hintText;
  final bool hasError;
  final bool autoEditComplete;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: numberCount * 12.5 + 5,
      margin: EdgeInsets.only(right: 10),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (String text) {
          onChange(text);
          if (autoEditComplete && text.length == numberCount) _focusNextInput(context);
        },
        onEditingComplete: () => _focusNextInput(context),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16),
          errorText: hasError ? "" : null,
          errorStyle: TextStyle(height: 0),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(numberCount),
          WhitelistingTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  void _focusNextInput(BuildContext context) {
    if (nextFocusNode != null)
      FocusScope.of(context).requestFocus(nextFocusNode);
    else
      focusNode.unfocus();
  }
}
