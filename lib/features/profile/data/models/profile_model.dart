import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? profession;
  final String? education;
  final String? countryCode;

  const ProfileModel({
    this.id,
    required this.fullName,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.profession,
    this.education,
    this.countryCode,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    bio,
    avatarUrl,
    coverUrl,
    profession,
    education,
    countryCode,
  ];

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String?,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'bio': bio,
      'avatar_url': avatarUrl,
      'cover_url': coverUrl,
      'profession': profession,
      'education': education,
      'country_code': countryCode,
    };
  }
}
