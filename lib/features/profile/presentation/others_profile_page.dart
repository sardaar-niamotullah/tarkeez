import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/connections/enums/connection_type.dart';
import 'package:tarkeez/features/profile/presentation/sections/personal_bests_section.dart';
import 'package:tarkeez/features/profile/presentation/sections/streaks.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/heatmap.dart';

class OthersProfilePage extends StatelessWidget {
  final ConnectionType connectionType;
  const OthersProfilePage({super.key, required this.connectionType});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    return StandAlonePageOuterStructure(
      isLoading: false,
      title: texts.profile,
      horizontalPadding: 0,
      actions: switch (connectionType) {
        ConnectionType.disconnected => [
          ActionButton(iconPath: SvgPaths.userPlus, onTap: () {}),
        ],
        ConnectionType.connected => [
          ActionButton(iconPath: SvgPaths.brokenLink, onTap: () {}),
        ],
        ConnectionType.requested => [
          ActionButton(iconPath: SvgPaths.userCross, onTap: () {}),
          const SizedBox(width: 8),
          ActionButton(iconPath: SvgPaths.userCheck, onTap: () {}),
        ],
        ConnectionType.pending => [
          ActionButton(iconPath: SvgPaths.userMinus, onTap: () {}),
        ],
      },

      // ─────────────────────────────────────────────────────────
      // Body content
      // ─────────────────────────────────────────────────────────
      content: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              // const ProfileHeader(isOwnProfileHeader: false),
              const SizedBox(height: 16),
              Container(
                padding: const .symmetric(
                  horizontal: ContainerDesignUtils.padding,
                ),
                child: Column(
                  children: [
                    const Heatmap(),
                    const SizedBox(height: 16),
                    const Streaks(),
                    const SizedBox(height: 16),
                    const PersonalBestsSection(isLocked: false),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
