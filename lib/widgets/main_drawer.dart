import 'package:flutter/material.dart';
import 'package:team_matching/screens/tabs_screen.dart';

import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).colorScheme.secondary,
          child: Text(
            'Team Matching',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(height: 20),
        buildListTile(Icons.restaurant, 'Profile', () {
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        }),
        buildListTile(Icons.restaurant, 'Project', () {
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        })
      ]),
    );
  }

  ListTile buildListTile(IconData icon, String title, Function tabHandler) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      onTap: () {
        tabHandler();
      },
    );
  }
}
