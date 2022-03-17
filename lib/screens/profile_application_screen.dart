import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/project.dart';
import 'package:team_matching/models/project_summary.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:team_matching/models/university.dart';
import 'package:team_matching/models/user.dart';

class ProfileApplication extends StatefulWidget {
  const ProfileApplication({Key? key}) : super(key: key);
  @override
  _ProfileApplicationState createState() => _ProfileApplicationState();
}

class _ProfileApplicationState extends State<ProfileApplication> {
  List<ProjectSummary> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppliedProject().then((value) => setState(() {
          _list = [..._list, ...value];
          _isLoading = false;
          print('asdasdsa');
          print(_list.length);
        }));
  }

  Future<List<ProjectSummary>> fetchAppliedProject() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    final response = await http.get(
      'https://startup-competition-api.azurewebsites.net/api/v1/student-in-project/current',
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    List<ProjectSummary> res = [];
    if (response.statusCode == 200) {
      List<dynamic> values;
      values = jsonDecode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            dynamic item1 = map['project'];
            dynamic item2 = map['student'];
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
    return DataTable(
      columnSpacing: 6,
      columns: <DataColumn>[
        DataColumn(
          label: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
              minWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
            ),
            child: const Text(
              'Project Name',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.5 * MediaQuery.of(context).size.width / 3 - 4,
              minWidth: 0.5 * MediaQuery.of(context).size.width / 3 - 4,
            ),
            child: const Text(
              'Status',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 3 - 4,
              minWidth: MediaQuery.of(context).size.width / 3 - 4,
            ),
            child: const Text(
              'Actions',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        buildRowItem(context),
        buildRowItem(context),
        ..._list
            .map(
              (e) => buildRowItem(context),
            )
            .toList(),
      ],
    );
  }

  DataRow buildRowItem(BuildContext context) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
              minWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
            ), //SET max width
            child: const Text('very long text blah blah blah blah blah blah',
                overflow: TextOverflow.ellipsis),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.5 * MediaQuery.of(context).size.width / 3 - 4,
              minWidth: 0.5 * MediaQuery.of(context).size.width / 3 - 4,
            ),
            child: const Text('Pending',
                overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.green)),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 3 - 4,
              minWidth: MediaQuery.of(context).size.width / 3 - 4,
            ), //SET max width
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.green),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
