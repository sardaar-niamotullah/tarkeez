import 'package:tarkeez/features/profile/data/models/profile_model.dart';

abstract final class DummyProfile {
  static const ProfileModel profile = ProfileModel(
    fullName: 'Your Full Name',
    email: 'youremail@address.com',
    bio: 'This is a placeholder bio used while the real profile loads.',
    profession: 'Student at Somewhere University',
    education: 'BRAC University',
    countryCode: 'BD',
  );
}