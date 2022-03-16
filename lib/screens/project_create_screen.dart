import 'package:flutter/material.dart';
import 'package:team_matching/models/project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/widgets/button_widget.dart';
import 'package:http/http.dart' as http;
import '../widgets/main_drawer.dart';
import 'dart:convert';

class CreateProjectScreen extends StatefulWidget {
  static const routeName = '/projects';
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late TextEditingController _controller;
  // Initial Selected Value
  String fieldDropdownValue = 'Business';
  // List of items in our dropdown menu
  var fieldItems = [
    'Business',
    'Marketing',
    'Technology',
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

  Future<Project> createProject(Project project) async {
    Map data = {
      'title': project.title,
      'description': project.description,
      'imageUrl': project.imageUrl,
      'status': -1,
      'field': project.field,
      'contactLink': project.contactLink,
      'application': project.application
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      'https://startup-competition-api.azurewebsites.net/api/v1/projects',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );
    Project? prj;
    if (response.statusCode == 200) {
      dynamic value;
      value = jsonDecode(response.body);
      if (value != null) {
        prj = Project(
          id: value['id'],
          title: value['title'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          status: value['status'],
          field: value['field'],
          contactLink: value['contactLink'],
          application: value['application'],
        );
      }
      return project;
    } else {
      throw Exception('Failed to Create Project');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Project"),
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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactLinkController = TextEditingController();
  final TextEditingController applicationDescriptionController =
      TextEditingController();
  final TextEditingController fieldController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  Container inputProject() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: titleController,
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
                "Description",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: descriptionController,
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
                "Field",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                selectedItemBuilder: (BuildContext context) {
                  return fieldItems.map<Widget>((String item) {
                    return Text(item);
                  }).toList();
                },
                value: fieldDropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (newValue) {
                  setState(() {
                    fieldDropdownValue = newValue!;
                  });
                },
                items: fieldItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Contact Link",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: contactLinkController,
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
                "Application Description",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: applicationDescriptionController,
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
                "Image URL",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                controller: imageUrlController,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
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
            text: 'Create',
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
                'Create Project',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ]),
      );
}
