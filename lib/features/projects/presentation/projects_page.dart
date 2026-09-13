import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/dummy_project.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_info_tile.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_page_info_tile.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state is ProjectLoaded) {
          if (state.isDeleted) {
            showSuccessSnackBar(
              context,
              message:
                  'Project deleted. Tracked time was moved to \'No project\'.',
            );
          } else if (state.isCreated) {
            showSuccessSnackBar(
              context,
              message: 'Project successfully created. You can now start tracking time on this project.',
            );
          } else if (state.isUpdated) {
            showSuccessSnackBar(
              context,
              message:
                  'Project successfully updated. Your changes have been saved.',
            );
          }
        }
        if (state is ProjectFailure) {
          showErrorSnackBar(context, message: state.errorMessage);
        }
      },
      builder: (context, state) {
        final isInitialLoading = state is ProjectLoading && state.isInitialLoad;
        final projects = switch (state) {
          ProjectLoaded s => s.projects,
          ProjectLoading s => s.projects ?? const [],
          _ => const <ProjectModel>[],
        };
        return Stack(
          children: [
            const Positioned.fill(child: HeroImageBackgroundLayer()),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  CustomAppBar(
                    title: texts.report,
                    isBackButtonEnabled: false,
                    actions: [ActionPageIcon(iconPath: SvgPaths.projects)],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: .hardEdge,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: ContainerDesignUtils.topRadius,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverList.list(
                      children: [
                        SizedBox(height: 16),
                        ProjectPageInfoTile(),
                        SizedBox(height: 16),
                        Text('Your projects', style: TextUtils.title2(context)),
                        SizedBox(height: 8),
                      ],
                    ),
                    if (projects.isNotEmpty)
                      SliverList.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, i) => ProjectInfoTile(
                          project: projects[i],
                          tileColor: i % 2 == 0
                              ? scheme.onSurface
                              : scheme.surface,
                        ),
                      ),
                    if (projects.isEmpty &&
                        !isInitialLoading &&
                        state is! ProjectFailure)
                      SliverToBoxAdapter(
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
                      ),
                    if (state is ProjectFailure)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const .only(top: 128),
                          child: Text(
                            state.errorMessage,
                            style: TextUtils.paragraph(
                              context,
                              color: scheme.onTertiary.withValues(alpha: .7),
                            ),
                            textAlign: .center,
                          ),
                        ),
                      ),
                    if (isInitialLoading)
                      SliverSkeletonizer(
                        enabled: true,
                        child: SliverList.builder(
                          itemCount: 4,
                          itemBuilder: (context, i) => ProjectInfoTile(
                            project: DummyProject.project,
                            tileColor: i % 2 == 0
                                ? scheme.onSurface
                                : scheme.surface,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
