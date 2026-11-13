import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/freemium_limits.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/premium_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/presentation/sections/add_or_update_project_dialog.dart';

class CreateNewProjectButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final projectState = context.read<ProjectBloc>().state;
          final count = switch (projectState) {
            ProjectLoaded s => s.projects.length,
            ProjectLoading s => s.projects?.length ?? 0,
            _ => 0,
          };
          final canAdd =
              context.read<PremiumCubit>().isPremium ||
              count < freeProjectLimit;

          showDialog(
            context: context,
            builder: (_) =>
                canAdd ? const AddOrUpdateProjectDialog() : GoPremiumDialog(),
          );
        },
        mouseCursor: SystemMouseCursors.click,
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          height: 40,
          width: 140.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [scheme.primaryContainer, scheme.primary],
            ),
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              Text(
                'Add project',
                style: TextUtils.paragraphBold(context, color: AppTheme.white),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                SvgPaths.projects,
                colorFilter: .mode(AppTheme.white, .srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
