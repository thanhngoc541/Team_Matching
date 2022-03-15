import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/models/project_summary.dart';
import 'package:team_matching/screens/project_detail_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class ProjectItem extends StatelessWidget {
  final ProjectSummary projectSummary;
  const ProjectItem({
    Key? key,
    required this.projectSummary,
  }) : super(key: key);

  Future<void> applyProject(context, projectId) async {
    if (projectId == null) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      'https://startup-competition-api.azurewebsites.net/api/v1/student-in-project?project-id=$projectId',
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 201) {
      popupMessage(context, "Ứng tuyển", "Ứng tuyển thành công");
    }
    if (response.statusCode == 400) {
      popupMessage(context, "Ứng tuyển", "Bạn đã ứng tuyển vào dự án này");
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load project');
    }
  }

  void _selectProject(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(ProjectDetailScreen.routeName, arguments: projectSummary.project?.id);
  }

  String get statusText {
    switch (projectSummary.project!.status) {
      case -1:
        return 'đang chờ duyệt';
      case 0:
        return 'đang tuyển';
      case 1:
        return 'ngừng hoạt động';
      case 2:
        return 'ngừng tuyển';
      default:
        return 'Unknown';
    }
  }

  Color get statusColor {
    switch (projectSummary.project!.status) {
      case -1:
        return Colors.orange;
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectProject(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    projectSummary.project!.imageUrl!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: 250,
                    color: Colors.black54,
                    child: Column(children: <Widget>[
                      Text(projectSummary.project!.title!,
                          style: const TextStyle(fontSize: 26, color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.fade),
                      Row(children: <Widget>[
                        Icon(Icons.circle, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ]),
                    ]),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: avatarBuilder(),
              ),
              title: Text(
                projectSummary.user!.fullName!,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(projectSummary.user!.university!.name!, maxLines: 2),
              trailing: MediaQuery.of(context).size.width > 360
                  ? TextButton.icon(
                      onPressed: () => {applyProject(context, projectSummary.project?.id)},
                      icon: Icon(Icons.arrow_circle_right, color: Theme.of(context).errorColor),
                      label:
                          Text('Ứng tuyển', style: TextStyle(color: Theme.of(context).errorColor)),
                    )
                  : ElevatedButton(
                      child: const Text('Ứng tuyển'),
                      onPressed: () => {applyProject(context, projectSummary.project?.id)}),
            ),
          ],
        ),
      ),
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

  Widget avatarBuilder() {
    return projectSummary.user?.avatarUrl?.isEmpty ?? true
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Text(projectSummary.user!.fullName!.substring(0, 1))),
          )
        : Image.network(
            projectSummary.user!.avatarUrl!,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          );
  }
}
