import 'dart:io';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/services/pick_image.dart';
import 'package:tarkeez/core/shared_files/buttons/select_file_source_button.dart';
import 'package:flutter/material.dart';

class ImageSourceSelectors extends StatelessWidget {
  final void Function(File file) onImagePicked;
  const ImageSourceSelectors({super.key, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    final pickImage = PickImageService();
    return Row(
      children: [
        Expanded(
          child: SelectFileSourceButton(
            isActive: true,
            iconPath: SvgPaths.folder,
            onTap: () async {
              final file = await pickImage.gallery();
              if (file != null) onImagePicked(file);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SelectFileSourceButton(
            isActive: true,
            iconPath: SvgPaths.camera,
            onTap: () async {
              final file = await pickImage.camera();
              if (file != null) onImagePicked(file);
            },
          ),
        ),
      ],
    );
  }
}
