import 'package:flutter/material.dart';
import 'package:tarkeez/core/theme/theme.dart';

class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppTheme.greyBright,
          borderRadius: .circular(99),
        ),
      ),
    );
  }
}
