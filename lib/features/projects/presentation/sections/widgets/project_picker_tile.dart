import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectPickerTile extends StatelessWidget {
  final int index;
  final ProjectModel? project;
  const ProjectPickerTile({super.key, required this.index, this.project});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedColor = scheme.onTertiary;
    final bool isLocked = true;

    return Row(
      children: [
        const SizedBox(width: 28),
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.transparent,
          child: Text('${index + 1}', style: TextUtils.paragraph(context)),
        ),
        Expanded(
          child: Text(
            project?.name ?? 'No project',
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .center,
            style: TextUtils.title2(context),
          ),
        ),
        Container(
          padding: .all(2),
          decoration: BoxDecoration(
            shape: .circle,
            color: resolvedColor.withValues(alpha: .5),
          ),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(shape: .circle, color: resolvedColor),
            child: !isLocked
                // ignore: dead_code
                ? null
                : Center(
                    child: SvgPicture.asset(
                      SvgPaths.lock,
                      height: 10,
                      colorFilter: .mode(scheme.onTertiary, .srcIn),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 28),
      ],
    );
  }
}
