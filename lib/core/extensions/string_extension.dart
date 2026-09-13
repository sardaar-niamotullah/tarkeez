extension StringExtension on String? {
  String? get returnNullIfStringIsEmpty {
    if (this == null) return null;
    if (this!.trim().isEmpty) return null;
    return this;
  }

  String? get capitalize {
    final value = this;
    if (value == null || value.trim().isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
