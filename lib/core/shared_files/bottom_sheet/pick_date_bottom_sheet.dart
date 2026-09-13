import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class PickDateBottomSheet extends StatelessWidget {
  final ValueChanged<DateTime> onDatePicked;

  const PickDateBottomSheet({super.key, required this.onDatePicked});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BottomSheetWrapper(
      contents: [
        SizedBox(
          height: 180,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextUtils.title1(context),
              ),
            ),
            child: CupertinoDatePicker(
              mode: .date,
              onDateTimeChanged: (date) => onDatePicked(date),
            ),
          ),
        ),
        const SizedBox(height: 16),
        CupertinoButton(
          child: Text(
            'Done',
            style: TextUtils.title2(context, color: scheme.primary),
          ),
          onPressed: () => context.pop(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
