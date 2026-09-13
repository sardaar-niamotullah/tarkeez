import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/features/connections/presentation/sections/widgets/connections_user_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OthersConnectionsPage extends StatelessWidget {
  const OthersConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);

    return StandAlonePageOuterStructure(
      isLoading: false,
      title: texts.connections,
      horizontalPadding: 0,
      actions: [ActionPageIcon(iconPath: SvgPaths.users)],
      content: CustomScrollView(
        slivers: [
          Skeletonizer.sliver(
            enabled: false,
            child: SliverList.builder(
              itemCount: 100,
              itemBuilder: (context, i) => PrimaryPageMargin(
                child: ConnectionsUserTile(
                  isEvenTile: i % 2 == 0,
                  crudConnectionType: .disconnectUser,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
