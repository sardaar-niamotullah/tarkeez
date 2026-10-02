import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_icon_button.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/maximum_width_box.dart';
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
          padding: const .only(left: 16, right: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(color: scheme.onSurface),
          child: Align(
            alignment: .center,
            child: MaximumWidthBox(
              maxWidth: Breakpoints.xl - 26,
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  BlocBuilder<ReportPeriodCubit, PeriodRange>(
                    builder: (context, period) => Text(
                      period.label,
                      style: TextUtils.paragraphBold(context),
                    ),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        iconPath: SvgPaths.filter,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => const ReportFilterBottomSheet(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
