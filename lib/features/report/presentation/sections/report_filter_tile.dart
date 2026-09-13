import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_icon_button.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/report_filter_bottom_sheet.dart';

class ReportFilterTile extends StatelessWidget {
  const ReportFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: false,
      floating: true,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 47,
      expandedHeight: 47,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: .only(left: 16, right: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(color: scheme.onSurface),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text('Last 7 days', style: TextUtils.paragraphBold(context)),
              Row(
                children: [
                  CustomIconButton(
                    iconPath: SvgPaths.filter,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const ReportFilterBottomSheet();
                      },
                    ),
                  ),
                  CustomIconButton(iconPath: SvgPaths.refresh, onTap: () {}),
                  CustomIconButton(iconPath: SvgPaths.download, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
