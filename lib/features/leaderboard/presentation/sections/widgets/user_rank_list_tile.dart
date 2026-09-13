import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/widgets/avatar_circle.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/connections/enums/connection_type.dart';

class UserRankListTile extends StatelessWidget {
  final int rank;
  final bool ownRank;
  const UserRankListTile({super.key, required this.rank, this.ownRank = false});

  static const _medals = {1: '🥇', 2: '🥈', 3: '🥉'};
  static const _rankSlotSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(
          RouteNames.othersProfilePage,
          extra: rank == 1
              ? ConnectionType.connected
              : rank == 2
              ? ConnectionType.disconnected
              : rank == 3
              ? ConnectionType.requested
              : ConnectionType.pending,
        ),
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          padding: const .only(top: 8, bottom: 8, left: 8, right: 12),
          decoration: BoxDecoration(
            color: !ownRank
                ? (rank % 2 == 0 ? scheme.onSurface : scheme.surface)
                : null,
            gradient: ownRank
                ? LinearGradient(
                    begin: .centerLeft,
                    end: .centerRight,
                    colors: [scheme.secondaryContainer, scheme.secondary],
                  )
                : null,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            children: [
              _buildRankIndicator(context),
              const SizedBox(width: 6),
              AvatarCircle(
                isEditable: false,
                radius: 18,
                outerCircleColor: rank % 2 == 0
                    ? scheme.surface
                    : scheme.onSurface,
                imageUrl:
                    'https://lh3.googleusercontent.com/a/ACg8ocJiOW7MX3yx9yEdIedMxgIEw3R5LtEMI_k2UOpH6xOqAKIHgkcHkg=s576-c-no',
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Sardaar Niamotullah',
                    style: TextUtils.paragraphBold(
                      context,
                      color: ownRank ? scheme.tertiary : null,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        SvgPaths.locationCircle,
                        height: 10,
                        colorFilter: .mode(
                          ownRank
                              ? scheme.tertiary.withValues(alpha: .9)
                              : scheme.onTertiary.withValues(alpha: .9),
                          .srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pabna',
                        style: TextUtils.paragraphSmall(
                          context,
                          color: ownRank ? scheme.tertiary : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              DurationTextUtils(
                durationInSeconds: 3801,
                fontColorPrimary: scheme.primaryContainer,
                fontColorSecondary: scheme.primaryContainer.withValues(
                  alpha: .75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankIndicator(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final medal = _medals[rank];
    return SizedBox(
      height: _rankSlotSize,
      width: _rankSlotSize,
      child: Center(
        child: medal != null
            ? Text(
                medal,
                style: TextUtils.paragraphSmallBold(
                  context,
                ).copyWith(fontSize: 22),
              )
            : FittedBox(
                fit: .scaleDown,
                child: Text(
                  rank.toString(),
                  maxLines: 1,
                  style: TextUtils.paragraphBold(
                    context,
                    color: ownRank ? scheme.tertiary : null,
                  ),
                ),
              ),
      ),
    );
  }
}
