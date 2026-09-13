class FormValidators {
  static String? validateName(String value) {
    final name = value.trim();
    if (name.length < 3 || name.length > 30) {
      return 'Name must be between 3 and 30 characters.';
    }
    return null;
  }

  static String? validateBio(String value) {
    final bio = value.trim();
    if (bio.isNotEmpty && (bio.length < 3 || bio.length > 150)) {
      return 'Bio must be between 3 and 150 characters.';
    }
    return null;
  }

  static String? validateProfession(String value) {
    final profession = value.trim();
    if (profession.isNotEmpty &&
        (profession.length < 3 || profession.length > 100)) {
      return 'Profession must be between 3 and 100 characters.';
    }
    return null;
  }

  static String? validateEducation(String value) {
    final education = value.trim();
    if (education.isNotEmpty &&
        (education.length < 3 || education.length > 100)) {
      return 'Education must be between 3 and 100 characters.';
    }
    return null;
  }

  static String? validateReport(String value) {
    if (value.isEmpty) return 'Providing a issue is required.';
    if (value.isNotEmpty && (value.length < 10 || value.length > 300)) {
      return 'Issue must be at 10-300 characters long.';
    }
    return null;
  }
}
