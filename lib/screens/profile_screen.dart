import 'package:flutter/material.dart';
import 'package:team_matching/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/screens/edit_profile_screen.dart';
import 'package:team_matching/utils/user_preferences.dart';
import 'package:team_matching/widgets/button_widget.dart';
import 'package:team_matching/widgets/numbers_widget.dart';
import 'package:team_matching/widgets/profile_widget.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import '../widgets/main_drawer.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _controller;
  final _user = UserPreferences.myUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _controller = TextEditingController();
    dynamic userId = ModalRoute.of(context)!.settings.arguments;
    if (userId != null) {
      fetchUserInfo(userId).then(((value) => {
        // setState(() {
        //   _user = value;
        // })
      }));
    }
    super.didChangeDependencies();
  }
  Future<User> fetchUserInfo(userId) async {
    final response = await http.get(
      'https://startup-competition-api.azurewebsites.net/api/v1/students/$userId',
    );
    if (response.statusCode == 200) {
      dynamic value;
      User user = const User(id: -1);
      value = jsonDecode(response.body);
      if (value != null) {
        user = User(
          id: value['user']['id'],
          fullName: value['user']['fullName'],
          address: value['user']['address'],
          phoneNumber: value['user']['phoneNumber'],
          gender: value['user']['gender'],
          doB: value['user']['doB'],
          email: value['user']['email'],
        );
      }
      return user;
    } else {
      throw Exception('Failed to load User profile');
    }
  }

  Future<User> editUserInfo(User user) async {
    int userId = user.id;
    Map data = {
      'id': user.id,
      'fullName': user.fullName,
      'address': user.address,
      'phoneNumber': user.phoneNumber,
      'gender': user.gender,
      'doB': user.doB,
      'email': user.email
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      'https://startup-competition-api.azurewebsites.net/api/v1/students/$userId',
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
        dynamic value;
        value = jsonDecode(response.body);
        if (value != null) {
            user = User(
            id: value['id'],
            fullName: value['fullName'],
            address: value['address'],
            phoneNumber: value['phoneNumber'],
            gender: value['gender'],
            doB: value['doB'],
            email: value['email'],
            );
        }
        return user;
    }
    else{
      throw Exception('Failed to update user');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        drawer: const Drawer(child: MainDrawer()),
        body: Column(
          children: [
            ProfileWidget(
              imagePath: "https://iheartcraftythings.com/wp-content/uploads/2021/05/How-to-draw-tree-7.jpg",
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            const SizedBox(),
            buildName(user),
            const SizedBox(),
            Center(child: buildUpgradeButton()),
            const SizedBox(),
            NumbersWidget(),
            const SizedBox(),
            buildAbout(user),
          ],
        )
      ),
    );
  }

}
  Widget buildName(User user) => Column(
        children: [
          Text(
            user.fullName!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.address!,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.phoneNumber!,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.gender!.toString(),
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.doB!,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.email!,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
      
 Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.address.toString(),
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );