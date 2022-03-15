import 'package:flutter/material.dart';
import 'package:team_matching/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late User _user = const User(id: id);
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
        setState(() {
          _user = value;
        })
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
    return (
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              Center(child: buildUpgradeButton()),
              const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(user),
            ],
          ),
        ),
      ),
    );
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
}
