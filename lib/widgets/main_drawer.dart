import 'package:flutter/material.dart';
import 'package:team_matching/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/screens/login_screen.dart';
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
                fontWeight: FontWeight.w900, fontSize: 30, color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(height: 20),
        buildListTile(Icons.architecture, 'Project', () {
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        }),
        // buildListTile(Icons.add_box_outlined, 'Create project', () {
        //   Navigator.of(context).pushReplacementNamed(CreateProjectScreen.routeName);
        // }),
        buildListTile(Icons.settings, 'Search', () {
          Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
        }),
        buildListTile(Icons.account_box, 'Profile', () {
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
        }),
        buildListTile(Icons.logout, 'Logout', () async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          //get token from shared preferences
          sharedPreferences.remove('token');
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }),
      ]),
    );
  }

  ListTile buildListTile(IconData icon, String title, Function tabHandler) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'RobotoCondensed', fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        tabHandler();
      },
    );
  }
}
