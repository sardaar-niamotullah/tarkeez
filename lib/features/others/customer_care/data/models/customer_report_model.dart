import 'package:equatable/equatable.dart';

enum CustomerReportMode { guest, authenticated }

class CustomerReportModel extends Equatable {
  final String id;
  final String? profileId;
  final String? fullName;
  final String report;
  final DateTime createdAt;

  const CustomerReportModel({
    required this.id,
    this.profileId,
    this.fullName,
    required this.report,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    profileId,
    fullName,
    report,
    createdAt,
  ];

  factory CustomerReportModel.fromJson(Map<String, dynamic> json) {
    return CustomerReportModel(
      id: json['id'] as String,
      profileId: json['user_id'] as String?,
      fullName: json['full_name'] as String?,
      report: json['report'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (profileId != null) 'user_id': profileId,
      if (fullName != null) 'full_name': fullName,
      'report': report,
    };
  }
}
