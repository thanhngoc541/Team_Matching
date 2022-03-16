import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/project.dart';
import 'package:team_matching/models/project_summary.dart';
import 'package:team_matching/models/university.dart';
import 'package:team_matching/widgets/project_item.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ProjectsScreen extends StatefulWidget {
  static const routeName = '/projects';
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<ProjectSummary> _list = [];
  bool _isLoading = true;
  int _pageIndex = 0;
  bool _isLastPage = false;
  @override
  void initState() {
    super.initState();
    fetchProject().then((value) => setState(() {
          _list = [..._list, ...value];
          _isLoading = false;
        }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('did');
  }

  Future<List<ProjectSummary>> fetchProject() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('status');
    Map data = {
      'searchString': "",
      'status': null,
      'pageSize': 5,
      'pageIndex': _pageIndex,
      'filter': {'field': ""}
    };
    final response = await http.post(
        'https://startup-competition-api.azurewebsites.net/api/v1/projects',
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: json.encode(data));
    List<ProjectSummary> res = [];
    if (response.statusCode == 200) {
      List<dynamic> values;
      values = jsonDecode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            dynamic item1 = map['item1'];
            dynamic item2 = map['item2'];
            ProjectSummary project = ProjectSummary(
                project: Project(
                  id: item1['id'],
                  application: item1['application'],
                  competitionId: item1['competitionId'],
                  contactLink: item1['contactLink'],
                  description: item1['description'],
                  field: item1['field'],
                  imageUrl: item1['imageUrl'],
                  projectSkills: item1['projectSkills'],
                  status: item1['status'],
                  title: item1['title'],
                ),
                user: item2 == null
                    ? null
                    : User(
                        id: item2['id'],
                        avatarUrl: item2['avatarUrl'],
                        fullName: item2['fullName'] ?? "",
                        university: University(
                            id: item2['university']['id'],
                            name: item2['university']['name'] ?? "")));
            res.add(project);
            // ProjectSummary ps = ProjectSummary(project: map['item1'], user: map['item2']);
          }
        }
      }
      return res;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load projects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? const Center(child: Text('No project'))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              final projectSummary = _list[index];
              if (index == _list.length - 1 && _isLastPage == false) {
                _pageIndex++;
                fetchProject().then((value) => setState(() {
                      _list = [..._list, ...value];
                      if (value.length < 5) {
                        _isLastPage = true;
                      }
                    }));
              }
              return ProjectItem(
                projectSummary: projectSummary,
              );
            },
            itemCount: _list.length,
          );
  }
}
