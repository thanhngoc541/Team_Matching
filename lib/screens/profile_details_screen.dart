import 'package:flutter/material.dart';
import 'package:team_matching/models/university.dart';
import 'package:team_matching/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/screens/profile_edit_screen.dart';
import 'package:team_matching/widgets/button_widget.dart';
import 'package:team_matching/widgets/profile_widget.dart';
import '../models/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileDetailScreen extends StatefulWidget {
  static const routeName = '/profile/detail';
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late TextEditingController _controller;
  late User user = const User(id: -1);
  bool _isLoading = true;

  @override
  void initState() {
    fetchUserInfo().then(((value) => {
          setState(() {
            user = value;
            _isLoading = false;
          })
        }));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<User> fetchUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.get(
        'https://startup-competition-api.azurewebsites.net/api/v1/students/current',
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      dynamic value;
      User user = const User(id: -1);
      value = jsonDecode(response.body);
      if (value != null) {
        user = User(
          id: value['student']['id'],
          fullName: value['student']['fullName'],
          address: value['student']['address'],
          avatarUrl: value['student']['avatarUrl'],
          phoneNumber: value['student']['phoneNumber'],
          gender: value['student']['gender'],
          doB: value['student']['doB'],
          email: value['student']['email'],
          university: University(
              id: value['student']['university']["id"],
              name: value['student']['university']["name"]),
          major: value['student']['major']["name"],
          fblink: value['student']['fblink'],
          year: value['student']['year'],
          department: value['student']['department']['name'],
        );
      }
      return user;
    } else {
      throw Exception('Failed to load User profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ProfileWidget(
                    imagePath:
                        "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png",
                    onClicked: () {},
                  ),
                  const SizedBox(height: 48),
                  buildInfo(user),
                  const SizedBox(height: 32),
                  Center(
                      child: ButtonWidget(
                    text: 'Edit profile',
                    onClicked: () async {
                      await Navigator.of(context)
                          .pushNamed(ProfileEditScreen.routeName, arguments: user);
                      fetchUserInfo().then(((value) => {
                            setState(() {
                              user = value;
                            })
                          }));
                    },
                  )),
                ],
              ),
            ),
          );
  }
}

Widget buildInfo(User user) => Column(
      children: [
        Text(
          user.fullName.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.phoneNumber.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          user.email.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          (user.university?.name).toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          (user.major).toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          (user.fblink ?? "").toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
      ],
    );
