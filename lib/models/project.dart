class Project {
  final int id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final int? status;
  final String? field;
  final String? contactLink;
  final int? competitionId;
  final String? application;
  final List<dynamic>? projectSkills;

  const Project(
      {required this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.status,
      this.field,
      this.contactLink,
      this.competitionId,
      this.application,
      this.projectSkills});
}
