import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);

    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(title: texts.sortBy, iconPath: SvgPaths.filter),
        const SizedBox(height: 8),
      ],
    );
  }
}
