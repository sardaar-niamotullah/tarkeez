import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/avatar_circle.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/app_bar_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';

class ProfileAppBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthSuccess ? state.user : null;
        return Container(
          height: appBarHeight(context),
          constraints: BoxConstraints(maxWidth: Breakpoints.lg - 8),
          padding: .symmetric(vertical: context.md ? 16 : 0),
          child: Row(
            crossAxisAlignment: context.md
                ? .end
                : isIOS
                ? .start
                : .center,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const .only(top: 2),
                  child: Row(
                    crossAxisAlignment: .center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, context.md ? 5 : 0),
                        child: AvatarCircle(
                          radius: context.md ? 18 : 16,
                          isEditable: false,
                          name: user?.fullName,
                          imageUrl: user?.avatarUrl,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.translate(
                        offset: Offset(0, context.md ? 5 : 0),
                        child: Text(
                          user?.fullName ?? 'Profile',
                          style: TextUtils.title1Normal(
                            context,
                            color: AppTheme.white,
                          ),
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, context.md ? 5 : 2.5),
                child: ActionButton(
                  boxSize: 28,
                  iconSize: 14,
                  iconPath: AssetPaths.info,
                  onTap: () => context.push(RouteNames.informationsPage),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }
}
