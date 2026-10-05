import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/floating_action_button_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/sliver_max_width_box.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/projects_list.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/create_new_project_button.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_page_info_tile.dart';

class ProjectsTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<ProjectBloc, ProjectState>(
      listener: (context, state) {
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
                    title: 'Projects',
                    isBackButtonEnabled: false,
                    actions: [ActionPageIcon(iconPath: SvgPaths.projects)],
                  ),
                  Expanded(
                    child: Container(
                      clipBehavior: .hardEdge,
                      padding: .symmetric(
                        horizontal: ContainerDesignUtils.padding,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: ContainerDesignUtils.topRadius,
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverMaxWidthBox(
                            sliver: SliverMainAxisGroup(
                              slivers: [
                                SliverList.list(
                                  children: [
                                    const SizedBox(height: 16),
                                    // SimulationPart(),
                                    const ProjectPageInfoTile(),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Your projects',
                                      style: TextUtils.title2(context),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                ProjectsList(
                                  projects: projects,
                                  isInitialLoading: isInitialLoading,
                                  errorMessage: state is ProjectFailure
                                      ? state.errorMessage
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButtonWrapper(actionButton: CreateNewProjectButton()),
          ],
        );
      },
    );
  }
}
