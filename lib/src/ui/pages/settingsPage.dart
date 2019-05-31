
import 'package:birthdays/src/resources/settings.dart';
import 'package:flutter/material.dart';
import 'package:birthdays/src/ui/widgets/pageScaffold.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      isSubpage: true,
      title: "Settings",
      body: _SettingsList(),
    );
  }
}


class _SettingsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsListState();
}

class _SettingsListState extends State<_SettingsList>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Vor dem Löschen bestätigen"),
          trailing: Switch(
            value: Settings.confirmDelete,
            onChanged: (value) {
              Settings.confirmDelete = value;
              setState(() {});
            },
          ),
        )
      ],
    );
  }
}

