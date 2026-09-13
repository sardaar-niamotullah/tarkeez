import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DataUsageCard extends StatelessWidget {
  final double usedMB;
  final double freeLimitMB;

  const DataUsageCard({
    super.key,
    required this.usedMB,
    required this.freeLimitMB,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = (usedMB / freeLimitMB).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const .symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .end,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Data Usage', style: TextUtils.paragraph(context)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${usedMB.toStringAsFixed(2)} ',
                          style: TextUtils.paragraphBold(
                            context,
                            color: scheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: 'MB',
                          style: TextUtils.paragraphSmall(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'of ${freeLimitMB.toInt()} MB free',
                style: TextUtils.paragraphSmall(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: .circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: scheme.outlineVariant.withValues(alpha: .3),
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextUtils.paragraphSmall(context),
              children: [
                const TextSpan(text: 'After 100 MB, '),
                TextSpan(
                  text: '৳4/month ',
                  style: TextUtils.paragraphSmallBold(
                    context,
                    color: scheme.primary,
                  ),
                ),
                const TextSpan(text: 'is charged per '),
                TextSpan(
                  text: '100 MB',
                  style: TextUtils.paragraphSmallBold(context),
                ),
                const TextSpan(text: ' of data used.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
