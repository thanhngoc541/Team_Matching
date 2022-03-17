import 'package:flutter/material.dart';
import 'package:team_matching/screens/profile_application_screen.dart';
import 'package:team_matching/screens/profile_details_screen.dart';
import 'package:team_matching/screens/recommended_projects_screen.dart';
import '../widgets/main_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _controller;

  int _selectedTabIndex = 0;
  List<Map<String, dynamic>> _pages = [];
  String _titleAppbar = "Profile";

  @override
  void initState() {
    _pages = [
      {'page': const ProfileDetailScreen(), 'title': 'Profile'},
      {'page': const ProfileApplication(), 'title': 'My application'},
      {'page': const RecommendedProjectsScreen(), 'title': 'My team'},
    ];
    super.initState();
  }

  void _selectTab(index) {
    setState(() {
      _selectedTabIndex = index;
      if (index == 0) {
        _titleAppbar = "Profile";
      } else if (index == 1) {
        _titleAppbar = "My application";
      } else if (index == 2) {
        _titleAppbar = "My team";
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(_titleAppbar),
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
            BottomNavigationBarItem(icon: Icon(Icons.verified_user_sharp), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My application'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'My team'),
          ],
        ),
      ),
    );
  }
}
