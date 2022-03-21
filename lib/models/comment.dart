import 'package:team_matching/models/user.dart';

class Comment {
  final int? id;
  final String? content;
  final String? commentTime;
  final User? student;

  const Comment({this.id, this.content, this.commentTime, this.student});
}
