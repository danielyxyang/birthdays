
import 'package:birthdays/src/blocs/blocProvider.dart';
import 'package:birthdays/src/blocs/importBirthdaysBloc.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/ui/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:birthdays/src/ui/widgets/pageScaffold.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class ImportBirthdaysPage extends StatefulWidget {
  @override
  _ImportBirthdaysPageState createState() => _ImportBirthdaysPageState();
}

class _ImportBirthdaysPageState extends State<ImportBirthdaysPage> {
  String _path;
  int _mode = _NO_FILE_SELECTED;
  static const _NO_FILE_SELECTED = 0;
  static const _CHECK_BIRTHDAYS = 1;
  static const _IMPORT_BIRTHDAYS = 2;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      isSubpage: true,
      title: "Importiere Geburtstage",
      appBarActions: <Widget>[
        _buildActionButton(),
      ],
      body: _mode == _NO_FILE_SELECTED ? Center(
        child: RaisedButton(
          child: Text("Importiere CSV-Datei"),
          onPressed: () async {
            final path = await FlutterDocumentPicker.openDocument(params: FlutterDocumentPickerParams(
              allowedFileExtensions: ["csv"],
            ));
            if (path != null) setState(() {
              _mode = _CHECK_BIRTHDAYS;
              _path = path;
            });
          },
        ),
      ) : _ImportBirthdayList(path: _path),
    );
  }
  Widget _buildActionButton() {
    switch(_mode) {
      case _CHECK_BIRTHDAYS: return IconButton(
        icon: Icon(Icons.check),
        tooltip: "Importieren",
        onPressed: () async {
          if (await showConfirmDialog(context, "Durch das Importieren werden alle vorherigen Geburtstage gelöscht. Trotzdem fortfahren?", "Importieren")) {
            setState(() => _mode = _IMPORT_BIRTHDAYS);
            await Provider.of<ImportBirthdaysBloc>(context).importBirthdays();
            Navigator.pop(context);
          }
        },
      );
      case _IMPORT_BIRTHDAYS:
        return IconButton(
          icon: Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            child: CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 3),
          ),
          onPressed: () {},
        );
      default: return Container();
    }
  }
}

class _ImportBirthdayList extends StatefulWidget {
  _ImportBirthdayList({this.path});
  final String path;

  @override
  State<StatefulWidget> createState() => _ImportBirthdayListState();
}

class _ImportBirthdayListState extends State<_ImportBirthdayList>{
  ImportBirthdaysBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of<ImportBirthdaysBloc>(context);
    _bloc.fetchBirthdaysFromCSV(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Birthday>>(
      stream: _bloc.birthdaysStream,
      builder: (BuildContext context, AsyncSnapshot<List<Birthday>> snapshot) {
        if(snapshot.hasData)
          return Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: Icon(Icons.info, size: 32),
                  title: Text("Wähle die Geburtstage aus, die du importieren möchtest. Tippe auf einen Geburtstag, um diesen zu ändern."),
                ),
              ),
              Expanded(child: _buildBirthdaysList(snapshot.data)),
            ],
          );
        else if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildBirthdaysList(List<Birthday> birthdayList) {
    if (birthdayList.length == 0)
      return Center(child: Text("Keine Geburtstage gefunden!"));
    else
      return ListView.builder(
        padding: EdgeInsets.only(top: 5),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(height: 5);

          int index = i ~/ 2;
          if (index >= birthdayList.length) return null;

          final birthday = birthdayList[index];
          return ListTile(
            leading: Checkbox(
              value: birthday.favorite,
              onChanged: (value) => _bloc.enableBirthday(birthday.id, value),
            ),
            title: Text(birthday.name),
            trailing: Text(birthday.date.format(birthday.date.year != Birthday.UNDEFINED_YEAR ? "dd.MM.yyyy" : "dd.MM")),
            onTap: () async {
              Birthday newBirthday = await showUpdateBirthdayDialog(context, birthday);
              if (newBirthday != null)
                _bloc.updateBirthday(newBirthday);
            },
          );
        },
      );
  }
}
