import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TimeChip extends StatelessWidget {
  final int seconds;
  final Color? fontColor;
  const TimeChip({super.key, required this.seconds, this.fontColor});

  @override
  Widget build(BuildContext context) {
    final durationInMinutes = seconds ~/ 60;
    final hours = durationInMinutes ~/ 60;
    final mins = durationInMinutes % 60;
    return Row(
      mainAxisSize: .min,
      children: [
        _buildTimeChip(context, duration: '${hours}h'),
        const SizedBox(width: 4),
        _buildTimeChip(context, duration: '${mins}m'),
      ],
    );
  }

  Widget _buildTimeChip(BuildContext context, {required String duration}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color:
            fontColor?.withValues(alpha: 0.08) ??
            scheme.onTertiary.withValues(alpha: 0.08),
        borderRadius: .circular(4),
      ),
      child: Text(
        duration,
        style: TextUtils.paragraphBold(
          context,
          color:
              fontColor?.withValues(alpha: 0.7) ??
              scheme.onTertiary.withValues(alpha: 0.7),
        ).copyWith(fontSize: 9),
      ),
    );
  }
}
