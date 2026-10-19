class FormValidators {
  static String? validateProjectName(String value) {
    final name = value.trim();
    if (name.length < 3 || name.length > 20) {
      return 'Name must be between 3 and 20 characters.';
    }
    return null;
  }
}
