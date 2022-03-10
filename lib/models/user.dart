import 'package:team_matching/models/university.dart';

class User {
  final int id;
  final String? fullName;
  final String? address;
  final String? phoneNumber;
  final int? gender;
  final String? doB;
  final String? email;
  final int? departmentId;
  final String? password;
  final String? rollNumber;
  final String? createdTime;
  final String? fblink;
  final String? avatarUrl;
  final int? year;
  final int? competitionId;
  final int? projectId;
  final int? status;
  final int? majorId;
  final int? universityId;
  final dynamic department;
  final dynamic major;
  final University? university;

  const User(
      {required this.id,
      this.fullName,
      this.address,
      this.phoneNumber,
      this.gender,
      this.doB,
      this.email,
      this.departmentId,
      this.password,
      this.rollNumber,
      this.createdTime,
      this.fblink,
      this.avatarUrl,
      this.year,
      this.competitionId,
      this.projectId,
      this.status,
      this.majorId,
      this.universityId,
      this.department,
      this.major,
      this.university});
}
