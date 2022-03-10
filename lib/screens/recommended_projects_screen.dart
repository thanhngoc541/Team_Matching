import 'package:flutter/material.dart';
import 'package:team_matching/widgets/project_item.dart';

import '../dummy_data.dart';

class RecommendedProjectsScreen extends StatelessWidget {
  static const routeName = '/projects';
  const RecommendedProjectsScreen({Key? key}) : super(key: key);

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
