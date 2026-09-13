import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/extensions/string_extension.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/data/models/profile_model.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/user_info_line.dart';

class UserInfoSection extends StatelessWidget {
  final ProfileModel profile;
  final bool isOwnProfileInfo;
  const UserInfoSection({
    super.key,
    required this.profile,
    this.isOwnProfileInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: .all(ContainerDesignUtils.padding),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        children: [
          const SizedBox(height: 42),
          Row(
            children: [
              Flexible(
                child: Text(
                  profile.fullName,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextUtils.title1Normal(context),
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                SvgPaths.medal,
                colorFilter: ColorFilter.mode(
                  AppTheme.trophyGold,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (profile.bio.returnNullIfStringIsEmpty != null)
            Padding(
              padding: const .only(bottom: 8),
              child: Align(
                alignment: .centerLeft,
                child: Text(
                  profile.bio!,
                  style: TextUtils.paragraph(context),
                  textAlign: .left,
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
              ),
            ),
          if (profile.profession.returnNullIfStringIsEmpty != null)
            UserInfoLine(
              title: profile.profession!,
              iconPath: SvgPaths.briefcase,
            ),
          if (profile.education.returnNullIfStringIsEmpty != null)
            UserInfoLine(
              title: profile.education!,
              iconPath: SvgPaths.academicCap,
            ),
          Row(
            children: [
              if (profile.countryCode.returnNullIfStringIsEmpty != null)
                Flexible(
                  child: UserInfoLine(
                    title: profile.countryCode ?? '—',
                    iconPath: SvgPaths.locationCircle,
                  ),
                ),
              Flexible(
                child: UserInfoLine(
                  title: '500+ Connections',
                  iconPath: SvgPaths.users,
                  onTap: () => context.push(
                    isOwnProfileInfo
                        ? RouteNames.connectionsPage
                        : RouteNames.othersConnectionsPage,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
