import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/app_update_cubit.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AppDrawerButton extends StatelessWidget {
  const new({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final storeUrl = context.watch<AppUpdateCubit>().state;
    return Listener(
      behavior: .opaque,
      onPointerUp: (_) {
        if (!context.md) onTap();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: .circular(4),
          mouseCursor: SystemMouseCursors.click,
          child: Row(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              if (!context.sm) ...[
                SvgPicture.asset(
                  height: 26,
                  (storeUrl == null)
                      ? AssetPaths.hamburger
                      : AssetPaths.hamburgerNotificaiton,
                  colorFilter: .mode(AppTheme.white, .srcIn),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                'Tarkeez',
                style: TextUtils.title1Normal(context, color: AppTheme.white),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
