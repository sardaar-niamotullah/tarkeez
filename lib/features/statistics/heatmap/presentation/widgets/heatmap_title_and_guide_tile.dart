import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/widgets/heatmap_point.dart';

class HeatmapTitleAndGuideTile extends StatelessWidget {
  const HeatmapTitleAndGuideTile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .end,
      children: [
        Text('Heatmap', style: TextUtils.title2(context)),
        Container(
          padding: .symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            children: [
              Text(
                'Less',
                style: TextUtils.paragraphSmall(context).copyWith(fontSize: 10),
              ),
              SizedBox(width: 4),
              HeatmapPoint(minute: 0),
              HeatmapPoint(minute: 15),
              HeatmapPoint(minute: 150),
              HeatmapPoint(minute: 300),
              HeatmapPoint(minute: 600),
              SizedBox(width: 4),
              Text(
                'More',
                style: TextUtils.paragraphSmall(context).copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
