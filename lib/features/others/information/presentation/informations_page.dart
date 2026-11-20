import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/info_tile.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';

class InformationsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final infos = [
      'A day counts toward your streak and heatmap once you complete at least 30 minutes of focus time.',
      'Please connect to the internet at least once a month. Data that stays offline for more than a month cannot be backed up to the cloud, for security reasons, and may be removed from this device.',
      'Your data is backed up automatically whenever you\'re online, so you rarely need the Back Up button on the Profile tab. The button also works as a sync: use it to back up your latest sessions and to bring sessions recorded on another device to this one right away.',
    ];

    return StandAlonePageOuterStructure(
      title: 'Informations',
      actions: [ActionPageIcon(iconPath: AssetPaths.info)],
      content: SliverScrollMaxWidthBox(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverList.builder(
            itemCount: infos.length,
            itemBuilder: (context, index) {
              return InfoTile(indexNumber: index, text: infos[index]);
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
