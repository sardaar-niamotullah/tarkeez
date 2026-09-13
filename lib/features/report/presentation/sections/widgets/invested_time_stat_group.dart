import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/emoji_badge.dart';

class InvestedTimeStatGroup extends StatelessWidget {
  final String emoji;
  final Color accentColor;
  final String topLabel;
  final int topSeconds;
  final String bottomLabel;
  final int bottomSeconds;
  final String? middleLabel;
  final int? middleSeconds;
  
  const InvestedTimeStatGroup({
    super.key,
    required this.emoji,
    required this.accentColor,
    required this.topLabel,
    required this.topSeconds,
    required this.bottomLabel,
    required this.bottomSeconds,
    this.middleLabel,
    this.middleSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ValueRow(label: topLabel, seconds: topSeconds),
          const SizedBox(height: 6),
          if (middleSeconds == null) EmojiBadge(emoji: emoji, isPrimary: false),
          if (middleSeconds != null)
            _ValueRow(label: middleLabel!, seconds: middleSeconds!),
          const SizedBox(height: 6),
          _ValueRow(label: bottomLabel, seconds: bottomSeconds),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final int seconds;

  const _ValueRow({required this.label, required this.seconds});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DurationTextUtils(
          durationInSeconds: seconds,
          fontSizePrimary: 16,
          fontSizeSeconday: 10,
          middleGap: 3,
        ),
        Text(
          label,
          style: TextUtils.paragraphSmall(
            context,
            color: scheme.onTertiary.withValues(alpha: 0.5),
          ).copyWith(fontSize: 10, letterSpacing: 0.2),
        ),
      ],
    );
  }
}