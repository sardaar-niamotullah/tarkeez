import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/presentation/sections/add_or_update_project_dialog.dart';

class CreateNewProjectButton extends StatelessWidget {
  const CreateNewProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => const AddOrUpdateProjectDialog(),
        ),
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          padding: .symmetric(
            horizontal: ContainerDesignUtils.padding,
            vertical: ContainerDesignUtils.halfPadding,
          ),
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
