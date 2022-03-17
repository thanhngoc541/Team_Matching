import 'package:flutter/material.dart';
import 'package:team_matching/screens/profile_details_screen.dart';
import 'package:team_matching/screens/profile_edit_screen.dart';
import 'package:team_matching/screens/profile_screen.dart';
import 'package:team_matching/screens/project_create_screen.dart';
import 'package:team_matching/screens/project_detail_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/categories_screen.dart';

import 'screens/tabs_screen.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Matching App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.pink,
              secondary: Colors.amber,
            ),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: const TextStyle(
                  fontSize: 20, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        CreateProjectScreen.routeName: (ctx) => const CreateProjectScreen(),
        TabsScreen.routeName: (ctx) => const TabsScreen(),
        ProjectDetailScreen.routeName: (ctx) => const ProjectDetailScreen(),
        FiltersScreen.routeName: (ctx) => const FiltersScreen(),
        ProfileEditScreen.routeName: (ctx) => const ProfileEditScreen()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const CategoriesScreen());
      },
    );
  }
}
