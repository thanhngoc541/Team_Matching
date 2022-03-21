import 'package:flutter/material.dart';
import 'package:team_matching/screens/project_create_screen.dart';
import 'package:team_matching/screens/projects_screen.dart';
import 'package:team_matching/screens/recommended_projects_screen.dart';
import 'package:team_matching/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/';
  const TabsScreen({Key? key}) : super(key: key);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CreateProjectScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Projects'),
        // Container(
        //     width: double.infinity,
        //     height: 40,
        //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        //     child: Center(
        //       child: TextField(
        //         onSubmitted: (value) async {
        //           SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        //           sharedPreferences.setString('searchString', value);
        //           setState(() {
        //             _controller = TextEditingController();
        //           });
        //         },
        //         controller: _controller,
        //         decoration: InputDecoration(
        //             prefixIcon: const Icon(Icons.search),
        //             suffixIcon: IconButton(
        //               icon: const Icon(Icons.clear),
        //               onPressed: () {
        //                 _controller.clear();
        //               },
        //             ),
        //             hintText: 'Search...',
        //             border: InputBorder.none),
        //       ),
        //     )),
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
