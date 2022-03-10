import 'package:flutter/material.dart';
import 'package:team_matching/screens/projects_screen.dart';
import 'package:team_matching/screens/recommended_projects_screen.dart';
import 'package:team_matching/widgets/main_drawer.dart';
import '../models/meal.dart';
import '../screens/categories_screen.dart';
import '../screens/favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  final List<Meal> favoriteMeals;
  const TabsScreen({Key? key, required this.favoriteMeals}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    _pages = [
      // {'page': const CategoriesScreen(), 'title': 'Categories'},
      {'page': const ProjectsScreen(), 'title': 'Projects'},
      {'page': const RecommendedProjectsScreen(), 'title': 'Recommended'},
      // {'page': FavoritiesScreen(favoriteMeals: widget.favoriteMeals), 'title': 'Your favorite'},
    ];
    super.initState();
  }

  void _selectTab(index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedTabIndex]['title'] as String),
      ),
      drawer: const Drawer(child: MainDrawer()),
      body: _pages[_selectedTabIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedTabIndex,
        items: const [
          // BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Recommended'),
          // BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
