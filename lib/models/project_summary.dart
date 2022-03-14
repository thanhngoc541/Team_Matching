import 'package:team_matching/models/project.dart';
import 'package:team_matching/models/user.dart';

class ProjectSummary {
  final Project? project;
  final User? user;

  const ProjectSummary({this.project, this.user});
}

class ProjectSummary2 {
  final Project? item1;
  final User? item2;

  const ProjectSummary2({this.item1, this.item2});
}
