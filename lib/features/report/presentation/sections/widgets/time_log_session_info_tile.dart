import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/date_formatter.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/time_log_project_pill.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

class TimeLogSessionInfoTile extends StatelessWidget {
  final SessionModel timeLog;
  final Color backgroundColor;
  const TimeLogSessionInfoTile({
    super.key,
    required this.timeLog,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: ContainerDesignUtils.halfPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                DateFormatter.readableDate(timeLog.startedAt.toLocal()),
                style: TextUtils.paragraphSmallBold(context),
              ),
              Row(
                children: [
                  Text(
                    DateFormatter.readableTime(timeLog.startedAt.toLocal()),
                    style: TextUtils.paragraphSmallBold(context),
                  ),
                  Text('  -  ', style: TextUtils.paragraphSmallBold(context)),
                  Text(
                    DateFormatter.readableTime(timeLog.endedAt.toLocal()),
                    style: TextUtils.paragraphSmallBold(context),
                  ),
                ],
              ),
            ],
          ),
          TimeLogProjectPill(
            project: ProjectModel(
              name: 'Some',
              colorId: 1,
              createdAt: DateTime(2025),
            ),
            width: 96,
          ),
          SizedBox(
            width: 70,
            child: Align(
              alignment: .centerEnd,
              child: DurationTextUtils(
                durationInSeconds: DateFormatter.durationInSeconds(
                  startedAt: timeLog.startedAt,
                  endedAt: timeLog.endedAt,
                ),
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
