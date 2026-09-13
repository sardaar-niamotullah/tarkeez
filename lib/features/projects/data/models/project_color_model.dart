import 'package:equatable/equatable.dart';

class ProjectColorModel extends Equatable {
  final int id;
  final String name;
  final String hexCode;

  const ProjectColorModel({
    required this.id,
    required this.name,
    required this.hexCode,
  });

  @override
  List<Object?> get props => [id, hexCode];

  factory ProjectColorModel.fromJson(Map<String, dynamic> json) {
    return ProjectColorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      hexCode: json['hex_code'] as String,
    );
  }
}