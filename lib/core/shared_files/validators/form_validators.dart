class FormValidators {
  static String? validateName(String value) {
    final name = value.trim();
    if (name.isEmpty || name.length > 20) {
      return 'Name must be between 1 and 20 characters.';
    }
    return null;
  }
}
