import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_matching/dummy_data.dart';
import 'package:team_matching/models/comment.dart';
import 'package:team_matching/models/project.dart';
import 'package:team_matching/models/project_summary.dart';
import 'package:team_matching/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class ProjectDetailScreen extends StatefulWidget {
  static const routeName = '/project-detail';
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late TextEditingController _controller;
  late ProjectSummary _projectSummary = const ProjectSummary();
  late List<Comment> _comments = [];
  int _pageIndex = 0;
  bool _isLastPage = false;
  bool _isLoading = true;
  bool _isLoadingComments = true;
  @override
  void didChangeDependencies() {
    _controller = TextEditingController();
    dynamic projectId = ModalRoute.of(context)!.settings.arguments;
    if (projectId != null) {
      fetchProject(projectId).then((value) => {
            setState(() {
              _projectSummary = ProjectSummary(project: value, user: DUMMY_PROJECTS[0].user);
              _isLoading = false;
            })
          });
      fetchProjectComments(projectId).then((value) => {
            setState(() {
              _comments = [..._comments, ...value];
              _isLoadingComments = false;
            })
          });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Project> fetchProject(projectId) async {
    final response = await http.get(
      'https://startup-competition-api.azurewebsites.net/api/v1/projects/$projectId',
    );
    if (response.statusCode == 200) {
      dynamic value;
      Project project = const Project(id: -1);
      value = jsonDecode(response.body);
      if (value != null) {
        project = Project(
          id: value['project']['id'],
          application: value['project']['application'],
          competitionId: value['project']['competitionId'],
          contactLink: value['project']['contactLink'],
          description: value['project']['description'],
          field: value['project']['field'],
          imageUrl: value['project']['imageUrl'],
          projectSkills: value['project']['projectSkills'],
          status: value['project']['status'],
          title: value['project']['title'],
        );
      }
      return project;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load project');
    }
  }

  Future<List<Comment>> fetchProjectComments(projectId) async {
    final response = await http.get(
      'https://startup-competition-api.azurewebsites.net/api/v1/projects/$projectId/comments?page=$_pageIndex&page-size=100',
    );
    List<Comment> res = [];
    if (response.statusCode == 200) {
      List<dynamic> values;
      values = jsonDecode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Comment cmt = Comment(
                id: values[i]['id'],
                commentTime: values[i]['commentTime'],
                content: values[i]['content'],
                student: User(
                  id: values[i]['student']['id'],
                  fullName: values[i]['student']['fullName'],
                  avatarUrl: values[i]['student']['avatarUrl'],
                ));
            res.add(cmt);
          }
        }
      }
      return res;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load projects');
    }
  }

  void doComment(projectId, content) {
    postComment(projectId, content).then((value) => {
          if (value != null)
            setState(() {
              _comments = [value, ..._comments];
            })
        });
  }

  Future<Comment?> postComment(projectId, content) async {
    Map data = {
      'projectId': projectId,
      'comment': content,
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      'https://startup-competition-api.azurewebsites.net/api/v1/comments',
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    Comment? cmt;
    if (response.statusCode == 201) {
      dynamic value;
      value = jsonDecode(response.body);
      if (value != null) {
        cmt = Comment(
          id: value['id'],
          commentTime: value['commentTime'],
          content: value['content'],
          student: User(
            id: value['student']['id'],
            fullName: value['student']['fullName'],
            avatarUrl: value['student']['avatarUrl'],
          ),
        );
      }
      return cmt;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to comment project');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarBuilder() {
      return _projectSummary.user?.avatarUrl?.isEmpty ?? true
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(child: Text(_projectSummary.user!.fullName!.substring(0, 1))),
            )
          : Image.network(
              _projectSummary.user!.avatarUrl!,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            );
    }

    return _isLoading == true
        ? const Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(_projectSummary.project!.title!),
              actions: <Widget>[
                IconButton(
                  onPressed: () => {_launchURL(_projectSummary.project!.contactLink)},
                  icon: const Icon(Icons.contact_page),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.network(_projectSummary.project!.imageUrl!, fit: BoxFit.cover),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 0.2,
                ),
                buildTitle(context, _projectSummary.project!.title!),
                buildContainer(Text(_projectSummary.project!.description!), context),
                const Divider(
                  color: Colors.black,
                  thickness: 0.2,
                ),
                buildTitle(context, "Thông tin ứng tuyển"),
                buildContainer(
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Text(
                        "Lĩnh vực: ${_projectSummary.project!.field}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.2,
                      ),
                      Text(_projectSummary.project!.application!),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.2,
                      ),
                      Wrap(
                        spacing: 0,
                        children: [
                          ...?_projectSummary.project!.projectSkills
                              ?.map((e) => Chip(
                                    label: Text(e),
                                  ))
                              .toList()
                        ],
                      ),
                    ]),
                    context),
                const Divider(
                  color: Colors.black,
                  thickness: 0.2,
                ),
                buildTitle(context, "Bình luận"),
                buildContainer(
                    Column(children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: avatarBuilder(),
                        ),
                        title: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Viết bình luận',
                            ),
                            controller: _controller,
                            onSubmitted: (String value) async {
                              // await showDialog<void>(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       title: const Text('Thanks!'),
                              //       content: Text(
                              //           'You typed "$value", which has length ${value.characters.length}.'),
                              //       actions: <Widget>[
                              //         TextButton(
                              //           onPressed: () {
                              //             Navigator.pop(context);
                              //           },
                              //           child: const Text('OK'),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );
                              doComment(_projectSummary.project?.id, value);
                              _controller.clear();
                            }),
                      ),
                      // _isLoadingComments == true
                      //     ? const Center(child: Text('Loading comments...'))
                      //     : ListView.builder(
                      //         itemBuilder: (ctx, index) {
                      //           final cmt = _comments[index];
                      //           // if (index == _comments.length - 1 && _isLastPage == false) {
                      //           //   _pageIndex++;
                      //           //   fetchProjectComments(_projectSummary.project?.id)
                      //           //       .then((value) => setState(() {
                      //           //             _comments = [..._comments, ...value];
                      //           //             if (value.length < 5) {
                      //           //               _isLastPage = true;
                      //           //             }
                      //           //           }));
                      //           // }
                      //           return buildComment(cmt);
                      //         },
                      //         itemCount: _comments.length,
                      //       ),
                      ..._comments.map((e) => buildComment(e)).toList()
                    ]),
                    context),
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          );
  }

  ListTile buildComment(Comment cmt) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        child: cmt.student!.avatarUrl == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text(cmt.student!.fullName!.substring(0, 1))),
              )
            : Image.network(
                cmt.student!.avatarUrl!,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
      title: Text(
        cmt.student!.fullName!,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(cmt.content!),
    );
  }

  void _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Container buildContainer(Widget child, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: child,
    );
  }

  Container buildTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }
}
