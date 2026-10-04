import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/dummy_project.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_info_tile.dart';

class ProjectsList extends StatelessWidget {
  const new({
    super.key,
    required this.projects,
    required this.isInitialLoading,
    this.errorMessage,
  });

  final List<ProjectModel> projects;
  final bool isInitialLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color tileColor(int i) => i % 2 == 0 ? scheme.onSurface : scheme.surface;
    if (isInitialLoading) {
      return SliverSkeletonizer(
        enabled: true,
        child: SliverList.builder(
          itemCount: 4,
          itemBuilder: (context, i) => ProjectInfoTile(
            project: DummyProject.project,
            tileColor: tileColor(i),
          ),
        ),
      );
    }
    if (errorMessage != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const .only(top: 128),
          child: Text(
            errorMessage!,
            style: TextUtils.paragraph(
              context,
              color: scheme.onTertiary.withValues(alpha: .7),
            ),
            textAlign: .center,
          ),
        ),
      );
    }

    if (projects.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const .only(top: 128),
          child: Text(
            'You don\'t have any projects to show. Add project to see projects in here.',
            style: TextUtils.paragraph(
              context,
              color: scheme.onTertiary.withValues(alpha: .7),
            ),
            textAlign: .center,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: projects.length,
      itemBuilder: (context, i) =>
          ProjectInfoTile(project: projects[i], tileColor: tileColor(i)),
    );
  }
}
