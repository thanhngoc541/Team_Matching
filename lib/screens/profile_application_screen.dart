import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/project.dart';
import 'package:team_matching/models/project_summary.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:team_matching/screens/project_detail_screen.dart';

class ProfileApplication extends StatefulWidget {
  const ProfileApplication({Key? key}) : super(key: key);
  @override
  _ProfileApplicationState createState() => _ProfileApplicationState();
}

class _ProfileApplicationState extends State<ProfileApplication> {
  List<ProjectSummary> _list = [];

  @override
  void initState() {
    super.initState();
    fetchAppliedProject().then((value) => setState(() {
          _list = [..._list, ...value];
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
            print(item1['id']);
            ProjectSummary project = ProjectSummary(
              project: Project(
                id: item1['id'],
                title: item1['title'],
              ),
            );
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

  Future<void> removeApplyProject(context, projectId) async {
    if (projectId == null) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.delete(
      'https://startup-competition-api.azurewebsites.net/api/v1/student-in-project/remove-application/$projectId',
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      setState(() {
        _list.removeWhere((element) => element.project?.id == projectId);
      });
      popupMessage(context, "Ứng tuyển", "Hủy ứng tuyển thành công");
    }
    if (response.statusCode == 400) {
      popupMessage(context, "Ứng tuyển", "Hủy ứng tuyển thất bại");
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load project');
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
              'Project Title',
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
        ..._list
            .map(
              (e) => buildRowItem(context, e),
            )
            .toList(),
      ],
    );
  }

  DataRow buildRowItem(BuildContext context, ProjectSummary projectSummary) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
              minWidth: 1.5 * MediaQuery.of(context).size.width / 3 - 4,
            ), //SET max width
            child: Text(projectSummary.project?.title ?? "", overflow: TextOverflow.ellipsis),
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
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProjectDetailScreen.routeName,
                        arguments: projectSummary.project?.id);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.red),
                  onPressed: () {
                    removeApplyProject(context, projectSummary.project?.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
}
