import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TimeLogIndexTile extends StatelessWidget {
  const TimeLogIndexTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text('Today', style: TextUtils.title2(context)),
        DurationTextUtils(
          durationInSeconds: 65321,
          fontSizePrimary: 18,
          fontSizeSeconday: 14,
        ),
      ],
    );
  }
}
