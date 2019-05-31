
import 'package:birthdays/src/resources/settings.dart';
import 'package:birthdays/src/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Settings.initSettings();
  initializeDateFormatting("de_DE", null).then((_) => runApp(BirthdayApp()));
}

class BirthdayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthdays',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) => Router.route(context, settings),
    );
  }
}
