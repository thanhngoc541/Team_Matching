import 'package:flutter/material.dart';
import 'package:team_matching/models/project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/user.dart';
import 'package:team_matching/widgets/button_widget.dart';
import 'package:http/http.dart' as http;
import '../widgets/main_drawer.dart';
import 'dart:convert';

class ProfileEditScreen extends StatefulWidget {
  static const routeName = '/profile/edit';
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<ProfileEditScreen> {
  late TextEditingController _controller;
  // Initial Selected Value
  String genderDropdownValue = 'Male';
  // List of items in our dropdown menu
  var genderItems = [
    'Male',
    'Female',
  ];
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
    //Call Create project
    super.didChangeDependencies();
  }

  Future<User> updateProfile(User user) async {
    Map data = {
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'gender': user.gender,
      'doB': user.doB,
      'university': user.university,
      'department': user.department,
      'major': user.major,
      'year': user.year,
      'fblink': user.fblink
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      'https://startup-competition-api.azurewebsites.net/api/v1/student/${user.id}',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );
    User? usr;
    if (response.statusCode == 200) {
      dynamic value;
      value = jsonDecode(response.body);
      if (value != null) {
        usr = User(
          id: value['id'],
          fullName: value['fullName'],
          phoneNumber: value['phoneNumber'],
          email: value['email'],
          status: value['status'],
          gender: value['gender'],
          doB: value['doB'],
          university: value['university'],
          department: value['department'],
          major: value['major'],
          year: value['year'],
          fblink: value['fblink'],
        );
      }
      return user;
    } else {
      throw Exception('Failed to Create Project');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          drawer: const Drawer(child: MainDrawer()),
          body: Column(
            children: <Widget>[
              headerSection(),
              const SizedBox(),
              inputProject(),
              const SizedBox(),
              Center(child: buttonActions()),
              // const SizedBox(),
              // createButton(),
              const SizedBox()
            ],
          )),
    );
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController linkFacebookController = TextEditingController();
  Container inputProject() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Full Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: fullNameController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Phone Number",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: phoneNumberController,
                cursorColor: Colors.black,
                // obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Email",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Gender",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                selectedItemBuilder: (BuildContext context) {
                  return genderItems.map<Widget>((String item) {
                    return Text(item);
                  }).toList();
                },
                value: genderDropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (newValue) {
                  setState(() {
                    genderDropdownValue = newValue!;
                  });
                },
                items:
                    genderItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "University",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: universityController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Major",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: majorController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Department",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: departmentController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Year",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: yearController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Facebook Link",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: linkFacebookController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              )
            ]));
  }

  Widget buttonActions() => Container(
      padding: EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        children: [
          ButtonWidget(
            text: 'Cancel',
            onClicked: () {},
          ),
          ButtonWidget(
            text: 'Update',
            onClicked: () {},
          )
        ],
      ));
  Widget headerSection() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ]),
      );
}
