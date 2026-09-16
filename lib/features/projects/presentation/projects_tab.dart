import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/create_new_project_button.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_page_info_tile.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              CustomAppBar(
                title: texts.projects,
                isBackButtonEnabled: false,
                actions: [ActionPageIcon(iconPath: SvgPaths.projects)],
              ),
              Expanded(
                child: Container(
                  clipBehavior: .hardEdge,
                  padding: .symmetric(horizontal: ContainerDesignUtils.padding),
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
                          Text(
                            'Your projects',
                            style: TextUtils.title2(context),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 16,
          right: 16,
          child: CreateNewProjectButton(),
        ),
      ],
    );
  }
}
