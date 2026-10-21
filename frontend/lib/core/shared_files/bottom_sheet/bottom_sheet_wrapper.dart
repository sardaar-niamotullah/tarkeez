import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_close_button.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_drag_handle.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class BottomSheetWrapper extends StatelessWidget {
  final List<Widget> contents;
  final double bottomMargin;
  const BottomSheetWrapper({
    super.key,
    required this.contents,
    this.bottomMargin = 16,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: .none,
      children: [
        Container(
          padding: const .symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: ContainerDesignUtils.topRadius,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              // Drag handle
              const SizedBox(height: 16),
              BottomSheetDragHandle(),
              const SizedBox(height: 16),
              ...contents,
              SizedBox(height: bottomMargin),
            ],
          ),
        ),
        // Close button
        BottomSheetCloseButton(),
      ],
    );
  }
}
