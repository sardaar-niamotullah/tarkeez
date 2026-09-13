import 'package:tarkeez/core/shared_files/bottom_sheet/pick_date_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DatePickerButton extends StatefulWidget {
  final ValueChanged<DateTime>? onDatePicked;
  final double verticalPadding;
  final DateTime? initialDate;

  const DatePickerButton({
    super.key,
    this.onDatePicked,
    this.verticalPadding = 8,
    this.initialDate,
  });

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(DatePickerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != null &&
        widget.initialDate != oldWidget.initialDate) {
      _selected = widget.initialDate!;
    }
  }

  String get _label {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${_selected.day} ${months[_selected.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          builder: (_) => PickDateBottomSheet(
            onDatePicked: (date) {
              setState(() => _selected = date);
              widget.onDatePicked?.call(date);
            },
          ),
        ),

        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          width: 110,
          padding: .symmetric(horizontal: 16, vertical: widget.verticalPadding),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              SvgPicture.asset(
                SvgPaths.calendarAdd,
                height: 18,
                colorFilter: .mode(
                  scheme.onTertiary.withValues(alpha: .75),
                  .srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(_label, style: TextUtils.paragraph(context)),
            ],
          ),
        ),
      ),
    );
  }
}
