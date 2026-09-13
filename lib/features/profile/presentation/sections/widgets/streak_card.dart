import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/emoji_badge.dart';

class StreakCard extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String title;
  final int streak;
  final String emoji;
  const StreakCard({
    super.key,
    required this.title,
    required this.streak,
    required this.emoji,
    this.mainAxisAlignment = .start,
    this.crossAxisAlignment = .start,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (mainAxisAlignment == .start) ...[
            EmojiBadge(emoji: emoji),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Row(
                  mainAxisSize: .min,
                  textBaseline: .alphabetic,
                  crossAxisAlignment: .baseline,
                  children: [
                    Text(
                      streak.toString(),
                      style: TextUtils.title3(context)
                          .copyWith(fontWeight: .bold),
                    ),
                    Text(
                      'day',
                      style: TextUtils.paragraphBold(
                        context,
                        color: scheme.onTertiary.withValues(alpha: 0.6),
                      ).copyWith(fontSize: 10),
                    ),
                  ],
                ),
                Text(
                  title,
                  style: TextUtils.paragraphSmall(context).copyWith(
                    fontSize: 10,
                    color: scheme.onTertiary.withValues(alpha: 0.5),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          if (mainAxisAlignment == .end) ...[
            const SizedBox(width: 8),
            EmojiBadge(emoji: emoji),
          ],
        ],
      ),
    );
  }
}
