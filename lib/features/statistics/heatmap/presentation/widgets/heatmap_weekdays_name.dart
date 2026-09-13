import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class HeatmapWeekdaysName extends StatelessWidget {
  const HeatmapWeekdaysName({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Sun'),
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Tue'),
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Thu'),
          buildWeekdaysNname(context, ''),
        ],
      ),
    );
  }

  Widget buildWeekdaysNname(BuildContext context, String name) {
    return SizedBox(
      height: 12,
      child: Text(
        name,
        style: TextUtils.paragraphSmall(context).copyWith(fontSize: 10),
      ),
    );
  }
}
