import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SetPomodoroDurationBottomSheet extends StatefulWidget {
  final ValueChanged<int> onDurationPicked;
  final int initialMinutes;

  const SetPomodoroDurationBottomSheet({
    super.key,
    required this.onDurationPicked,
    this.initialMinutes = 25,
  });

  @override
  State<SetPomodoroDurationBottomSheet> createState() =>
      _SetPomodoroDurationBottomSheetState();
}

class _SetPomodoroDurationBottomSheetState
    extends State<SetPomodoroDurationBottomSheet> {
  static const int _minMinutes = 5;
  static const int _maxMinutes = 120;
  static const int _minuteStep = 5;

  late int _selectedMinutes;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    final clampedMinutes = widget.initialMinutes.clamp(
      _minMinutes,
      _maxMinutes,
    );

    _selectedMinutes =
        ((clampedMinutes - _minMinutes) / _minuteStep).round() * _minuteStep +
        _minMinutes;

    _controller = FixedExtentScrollController(
      initialItem: (_selectedMinutes - _minMinutes) ~/ _minuteStep,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minuteCount = ((_maxMinutes - _minMinutes) ~/ _minuteStep) + 1;

    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(
          title: 'Set pomodoro length',
          iconPath: SvgPaths.stopwatch,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextUtils.title1(context),
              ),
            ),
            child: CupertinoPicker(
              scrollController: _controller,
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedMinutes = _minMinutes + (index * _minuteStep);
                });
              },
              children: List.generate(minuteCount, (index) {
                final minutes = _minMinutes + (index * _minuteStep);

                return Center(
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        minutes.toString(),
                        style: TextUtils.title1(context),
                      ),
                      const SizedBox(width: 4),
                      Text('minutes', style: TextUtils.title2(context)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: CancelButton(onPressed: () => context.pop())),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                title: 'Apply',
                onPressed: () {
                  widget.onDurationPicked(_selectedMinutes);
                  context.pop();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
