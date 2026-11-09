import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class HeatmapWeekdaysName extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Tue'),
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Thu'),
          buildWeekdaysNname(context, ''),
          buildWeekdaysNname(context, 'Sat'),
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
