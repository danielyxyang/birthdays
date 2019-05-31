
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  PageScaffold({this.title, this.body, this.appBarActions, this.floatingActionButton, this.isSubpage = false});
  final String title;
  final Widget body;
  final List<Widget> appBarActions;
  final Widget floatingActionButton;
  final bool isSubpage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: this.appBarActions,
      ),
      drawer: this.isSubpage ? null : _buildDrawer(context),
      body: this.body,
      floatingActionButton: this.floatingActionButton,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Image.asset("assets/images/party_icon_400.png"),
                  width: 100,
                ),
                Center(
                  child: Text(
                    "Never forget\na birthday!",
                    style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/drawer_background.png"),
                fit: BoxFit.cover,
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.import_export),
            title: Text("Import/Export"),
            onTap: () => Navigator.popAndPushNamed(context, "/import_birthdays"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () => Navigator.popAndPushNamed(context, "/settings"),
          ),
        ],
      ),
    );
  }
}
