import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pick(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;
    return File(image.path);
  }

  /// Opens the gallery multi-selector and returns at most limit files.
  /// Uses .take() to cap the result on older image_picker versions that
  /// don't accept a limit parameter natively.
  Future<List<File>> pickMultipleFromGallery({int limit = 3}) async {
    final List<XFile> images = await _picker.pickMultiImage();
    return images.take(limit).map((e) => File(e.path)).toList();
  }
}

extension PickImageExtension on PickImageService {
  Future<File?> gallery() => pick(ImageSource.gallery);
  Future<File?> camera() => pick(ImageSource.camera);
}
