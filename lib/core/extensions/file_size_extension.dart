import 'dart:io';

extension FileSizeExtension on File {
  Future<double> sizeInKB() async {
    final bytes = await length();
    return double.parse((bytes / 1024).toStringAsFixed(2));
  }

  Future<double> sizeInMB() async {
    final bytes = await length();
    return double.parse((bytes / (1024 * 1024)).toStringAsFixed(2));
  }

  Future<double> sizeInGB() async {
    final bytes = await length();
    return double.parse((bytes / (1024 * 1024 * 1024)).toStringAsFixed(2));
  }
}
