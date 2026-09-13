import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/date_formatter.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/time_log_project_pill.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/time_logs/data/models/time_log_model.dart';

class TimeLogSessionInfoTile extends StatelessWidget {
  final TimeLogModel timeLog;
  final Color backgroundColor;
  const TimeLogSessionInfoTile({
    super.key,
    required this.timeLog,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectBloc>().state;
    final projects = projectState is ProjectLoaded
        ? projectState.projects
        : (projectState is ProjectLoading ? projectState.projects : null);
    final resolvedProject = projects?.firstWhereOrNull(
      (p) => p.id == timeLog.projectId,
    );
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
          TimeLogProjectPill(project: resolvedProject, width: 96),
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
