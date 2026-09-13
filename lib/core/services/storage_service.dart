import 'dart:io';
import 'dart:typed_data';
import 'package:tarkeez/core/constants/db_table_and_storage_paths.dart';
import 'package:tarkeez/core/error/app_exception.dart';
import 'package:tarkeez/core/extensions/file_size_extension.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';

class StorageService {
  final SupabaseClient _supabase;

  StorageService(this._supabase);

  Future<String> uploadFile({
    required File file,
    required String path,
    required ProfileMediaType mediaType,
  }) async {
    final compressedFile = await _compressImage(
      file: file,
      targetSizeInKB: (mediaType == .avatar) ? 75 : 125,
    );

    final fileExtention = compressedFile.path.split('.').last.toLowerCase();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtention';
    final fullPath = '$path/$fileName';

    await _supabase.storage
        .from(DbTableAndStoragePaths.usersMedia)
        .upload(fullPath, compressedFile);

    final fileUrl = _supabase.storage
        .from(DbTableAndStoragePaths.usersMedia)
        .getPublicUrl(fullPath);
    return fileUrl;
  }

  Future<File> _compressImage({
    required File file,
    required int targetSizeInKB,
  }) async {
    final originalFileSize = await file.sizeInKB();
    debugPrint('🗂️ original file size: $originalFileSize KB');

    const minQuality = 30;
    const qualityStep = 10;
    const minDimension = 256;
    const dimensionStep = 32;

    int quality = 70;
    int dimension = 512;
    Uint8List? compressedImage;
    double compressedImageSize = .infinity;

    do {
      compressedImage = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
        format: CompressFormat.webp,
        minWidth: dimension,
        minHeight: dimension,
      );

      if (compressedImage == null) {
        throw const KnownException(
          'Could not process the selected image. Please try another one.',
        );
      }

      compressedImageSize = compressedImage.lengthInBytes / 1024;
      debugPrint(
        '🗂️ compressed: ${compressedImageSize.toStringAsFixed(2)} KB '
        '(quality: $quality, dimension: $dimension)',
      );

      if (compressedImageSize <= targetSizeInKB) break;

      if (dimension > minDimension) {
        dimension -= dimensionStep;
      } else {
        quality -= qualityStep;
      }
    } while (quality >= minQuality);

    if (compressedImageSize > targetSizeInKB) {
      throw const FileSizeTooLargeException();
    }

    final tempFile = File(
      '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.webp',
    );

    await tempFile.writeAsBytes(compressedImage);
    return tempFile;
  }

  Future<void> deleteFile({required String fileLink}) async {
    final uri = Uri.parse(fileLink);
    final segments = uri.pathSegments;
    final publicIndex = segments.indexOf('public');
    if (publicIndex == -1 || publicIndex + 2 >= segments.length) {
      throw Exception('Invalid Supabase storage URL');
    }
    final bucket = segments[publicIndex + 1];
    final filePath = segments.sublist(publicIndex + 2).join('/');
    final response = await _supabase.storage.from(bucket).remove([filePath]);
    if (response.isEmpty) {
      throw Exception('Delete returned empty list — RLS likely blocked it');
    }
  }
}
