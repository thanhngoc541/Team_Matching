import 'package:flutter/material.dart';
import 'package:team_matching/models/project_summary.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const routeName = '/project-detail';
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectSummary = ModalRoute.of(context)!.settings.arguments as ProjectSummary;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(projectSummary.project!.title!),
        actions: <Widget>[
          IconButton(
            onPressed: () => {_launchURL(projectSummary.project!.contactLink)},
            icon: const Icon(Icons.contact_page),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.network(projectSummary.project!.imageUrl!, fit: BoxFit.cover),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.2,
          ),
          buildTitle(context, projectSummary.project!.title!),
          buildContainer(Text(projectSummary.project!.description!), context),
          const Divider(
            color: Colors.black,
            thickness: 0.2,
          ),
          buildTitle(context, "Thông tin ứng tuyển"),
          buildContainer(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Text(
                  "Lĩnh vực: ${projectSummary.project!.field}",
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
                Text(projectSummary.project!.application!),
                const Divider(
                  color: Colors.black,
                  thickness: 0.2,
                ),
                Wrap(
                  spacing: 0,
                  children: [
                    ...?projectSummary.project!.projectSkills
                        ?.map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList()
                  ],
                )
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
                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Thanks!'),
                              content: Text(
                                  'You typed "$value", which has length ${value.characters.length}.'),
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
                      }),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: avatarBuilder(),
                  ),
                  title: Text(
                    projectSummary.user!.fullName!,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("hay"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: avatarBuilder(),
                  ),
                  title: Text(
                    projectSummary.user!.fullName!,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("Check ib vs a"),
                ),
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
