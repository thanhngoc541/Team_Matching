import 'package:flutter/material.dart';
import 'package:team_matching/widgets/project_item.dart';

import '../dummy_data.dart';

class ProjectsScreen extends StatelessWidget {
  static const routeName = '/projects';
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final projectSummary = DUMMY_PROJECTS[index];
        return ProjectItem(
          projectSummary: projectSummary,
        );
      },
      itemCount: DUMMY_PROJECTS.length,
    );
  }
}
