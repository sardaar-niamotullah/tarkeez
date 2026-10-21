import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';

class CustomerUpsertProfilePictureBottomSheet extends StatelessWidget {
  const CustomerUpsertProfilePictureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(
          title: 'Image selected',
          iconPath: SvgPaths.gitBranch,
        ),
        const SizedBox(height: 24),

        const SizedBox(height: 16),
      ],
    );
  }
}
