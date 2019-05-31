
import 'package:birthdays/src/blocs/blocProvider.dart';
import 'package:birthdays/src/blocs/importBirthdaysBloc.dart';
import 'package:birthdays/src/ui/pages/homePage.dart';
import 'package:birthdays/src/ui/pages/importBirthdaysPage.dart';
import 'package:birthdays/src/ui/pages/settingsPage.dart';
import 'package:flutter/material.dart';

import 'blocs/birthdayBloc.dart';

class Router {
  static Route route(BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(BlocProvider<BirthdaysBloc>(
          child: HomePage(),
          bloc: BirthdaysBloc(),
        ));
      case '/import_birthdays':
        return _buildRoute(BlocProvider<ImportBirthdaysBloc>(
          child: ImportBirthdaysPage(),
          bloc: ImportBirthdaysBloc(),
        ));
      case '/settings':
        return _buildRoute(SettingsPage());
      default:
        return null;
    }
  }

  static MaterialPageRoute _buildRoute(Widget widget) {
    return MaterialPageRoute(
      builder: (BuildContext context) => widget,
    );
  }
}
