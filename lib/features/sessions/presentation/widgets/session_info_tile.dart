import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/session_project_pill.dart';

class SessionInfoTile extends StatelessWidget {
  final SessionModel session;
  final Color backgroundColor;
  const SessionInfoTile({
    super.key,
    required this.session,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final projectState = context.watch<ProjectBloc>().state;
    final projects = projectState is ProjectLoaded
        ? projectState.projects
        : (projectState is ProjectLoading ? projectState.projects : null);
    final resolvedProject = projects?.firstWhereOrNull(
      (p) => p.id == session.projectId,
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
                DateTimeFormatter.readableDate(session.startedAt.toLocal()),
                style: TextUtils.paragraphSmallBold(context),
              ),
              Row(
                children: [
                  Text(
                    DateTimeFormatter.readableTime(session.startedAt.toLocal()),
                    style: TextUtils.paragraphSmallBold(context),
                  ),
                  Text('  -  ', style: TextUtils.paragraphSmallBold(context)),
                  Text(
                    DateTimeFormatter.readableTime(session.endedAt.toLocal()),
                    style: TextUtils.paragraphSmallBold(context),
                  ),
                ],
              ),
            ],
          ),
          SessionProjectPill(width: 74, project: resolvedProject),
          SizedBox(
            width: 70,
            child: Align(
              alignment: .centerEnd,
              child: DurationTextUtils(
                durationInSeconds: DateTimeFormatter.durationInSeconds(
                  startedAt: session.startedAt,
                  endedAt: session.endedAt,
                ),
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
            ),
          ),
          ActionButton(
            iconColor: scheme.error,
            iconPath: SvgPaths.delete,
            backgroundColor: scheme.error.withValues(alpha: .1),
            onTap: () => showDialog(
              context: context,
              builder: (_) => BlocConsumer<SessionBloc, SessionState>(
                listener: (context, state) {
                  if (state is SessionLoaded || state is SessionFailure) {
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return DeleteDialog(
                    isLoading: state is SessionLoading,
                    onDeleteTap: () => context.read<SessionBloc>().add(
                      DeleteSessionRequested(session),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
