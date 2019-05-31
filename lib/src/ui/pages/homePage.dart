
import 'package:birthdays/src/blocs/birthdayBloc.dart';
import 'package:birthdays/src/blocs/blocProvider.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/resources/settings.dart';
import 'package:birthdays/src/ui/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:birthdays/src/ui/widgets/pageScaffold.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Birthdays",
      appBarActions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.search),
//          tooltip: "Suche",
//          onPressed: () {Provider.of<BirthdaysBloc>(context).deleteAllBirthdays();},
//        ),
//        IconButton(
//          icon: Icon(Icons.refresh),
//          tooltip: "Refresh",
//          onPressed: () => Provider.of<BirthdaysBloc>(context).fetchAllBirthdays(),
//        ),
      ],
      body: BirthdayList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Birthday newBirthday = await showCreateBirthdayDialog(context);
          if (newBirthday != null) Provider.of<BirthdaysBloc>(context).addBirthday(newBirthday);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}


class BirthdayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BirthdayListState();
}

class BirthdayListState extends State<BirthdayList> {
  BirthdaysBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of<BirthdaysBloc>(context);
    _bloc.fetchAllBirthdays();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Birthday>>(
      stream: _bloc.birthdaysStream,
      builder: (BuildContext context, AsyncSnapshot<List<Birthday>> snapshot) {
        if (snapshot.hasData)
          return _buildBirthdayList(snapshot.data);
        else if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildBirthdayList(final List<Birthday> birthdayList) {
    if (birthdayList.length == 0)
      return Center(child: Text("Keine Geburtstage gefunden!"));
    else
      return ListView.builder(
        padding: EdgeInsets.only(top: 15.0),
        itemBuilder: (context, index) {
          if (index >= birthdayList.length) return null;

          final birthday = birthdayList[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            confirmDismiss: (direction) async {
              if (Settings.confirmDelete)
                return showConfirmDialog(context, "Möchtest du den Geburtstag von ${birthday.name} löschen?", "Löschen");
              else
                return true;
            },
            onDismissed: (direction) {
              _bloc.deleteBirthday(birthday.id);
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
              elevation: 2.0,
              child: ListTile(
                onTap: () async  {
                  Birthday newBirthday = await showUpdateBirthdayDialog(context, birthday);
                  if (newBirthday != null) _bloc.updateBirthday(newBirthday);
                },
                leading: _buildAgeCircle(birthday.age),
                title: Text(birthday.name),
                subtitle: Text(birthday.nextBirthday.format("E, d. MMMM")),
                trailing: _buildDaysToBirthday(birthday.duration),
              ),
            ),
          );
        },
      );
  }

  Widget _buildDaysToBirthday(String days) {
    List<String> textSplitted = days.split(" ");
    if (textSplitted.length == 2)
      return Column(
        children: <Widget>[Text(days.split(" ")[0]), Text(days.split(" ")[1])],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    else
      return Text(days);
  }

  Widget _buildAgeCircle(int age) {
    return Container(
      child: Text(
        age?.toString() ?? "?",
        style: TextStyle(fontSize: 16),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.amberAccent,
      ),
      width: 40,
      height: 40,
    );
  }
}

