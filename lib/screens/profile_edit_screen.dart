import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/user.dart';
import 'package:team_matching/widgets/button_widget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditScreen extends StatefulWidget {
  static const routeName = '/profile/edit';
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<ProfileEditScreen> {
  late TextEditingController fullNameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController genderController = TextEditingController();
  late TextEditingController dobController = TextEditingController();
  late TextEditingController universityController = TextEditingController();
  late TextEditingController majorController = TextEditingController();
  late TextEditingController departmentController = TextEditingController();
  late TextEditingController yearController = TextEditingController();
  late TextEditingController linkFacebookController = TextEditingController();
  late int userId;
  // Initial Selected Value
  int genderDropdownValue = 0;
  // List of items in our dropdown menu
  var genderItems = [
    {'name': 'Male', 'value': 0},
    {'name': 'Female', 'value': 1},
    {'name': 'Other', 'value': 2},
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    genderController.dispose();
    dobController.dispose();
    universityController.dispose();
    majorController.dispose();
    departmentController.dispose();
    yearController.dispose();
    linkFacebookController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    universityController = TextEditingController();
    majorController = TextEditingController();
    departmentController = TextEditingController();
    yearController = TextEditingController();
    linkFacebookController = TextEditingController();
    User _user = ModalRoute.of(context)!.settings.arguments as User;
    // ignore: unnecessary_null_comparison
    if (_user != null) {
      userId = _user.id;
      fullNameController.text = _user.fullName!;
      phoneNumberController.text = _user.phoneNumber!;
      emailController.text = _user.email!;
      dobController.text = _user.doB ?? "";
      universityController.text = _user.university!.name ?? "";
      majorController.text = _user.major ?? "";
      departmentController.text = _user.department ?? "";
      yearController.text = _user.year == null ? "" : _user.year.toString();
      linkFacebookController.text = _user.fblink ?? "";
    }
    //Call Create project
    super.didChangeDependencies();
  }

  Future<void> updateProfile() async {
    Map data = {
      'id': userId,
      'fullname': fullNameController.text,
      'phonenumber': phoneNumberController.text,
      'email': emailController.text,
      'gender': genderDropdownValue,
      'dob': dobController.text,
      'university': universityController.text,
      'department': departmentController.text,
      'major': majorController.text,
      'year': int.parse(yearController.text),
      'fblink': linkFacebookController.text,
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      'https://startup-competition-api.azurewebsites.net/api/v1/students/$userId',
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();

      popupMessage(context, "Cập nhật", "Cập nhật thành công");
    } else {
      popupMessage(context, "Cập nhật", "Cập nhật thất bại");
      throw Exception('Failed to Create Project');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
        ),
      ),
    );
  }

  Container inputProject() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          const Text(
            "Full Name",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: fullNameController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Phone Number",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: phoneNumberController,
            cursorColor: Colors.black,
            // obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Email",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Gender",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          DropdownButton<int>(
            value: genderDropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int? index) {
              setState(() {
                genderDropdownValue = index!;
              });
            },
            items: genderItems.map<DropdownMenuItem<int>>((dynamic value) {
              return DropdownMenuItem<int>(
                value: value['value'] as int,
                child: Text(value['name'] as String),
              );
            }).toList(),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "University",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: universityController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Major",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: majorController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Department",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: departmentController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Year",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: yearController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "Facebook Link",
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: linkFacebookController,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          )
        ]));
  }

  Widget buttonActions() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        children: [
          ButtonWidget(
            text: 'Cancel',
            onClicked: () {
              Navigator.of(context).pop();
            },
          ),
          ButtonWidget(
            text: 'Update',
            onClicked: () {
              updateProfile();
            },
          )
        ],
      ));
  Future<void> popupMessage(BuildContext context, String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget headerSection() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text(
            'Edit Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ]),
      );
}
