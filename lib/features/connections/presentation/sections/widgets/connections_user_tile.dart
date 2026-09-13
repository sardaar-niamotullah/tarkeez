import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/widgets/avatar_circle.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/connections/presentation/sections/widgets/crud_connection_button.dart';

class ConnectionsUserTile extends StatelessWidget {
  final CrudConnectionType crudConnectionType;
  final bool isEvenTile;

  const ConnectionsUserTile({
    super.key,
    required this.crudConnectionType,
    this.isEvenTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RouteNames.othersProfilePage),
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          padding: const .only(top: 8, bottom: 8, left: 8, right: 12),
          decoration: BoxDecoration(
            color: isEvenTile ? scheme.surface : scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            children: [
              AvatarCircle(
                isEditable: false,
                radius: 18,
                outerCircleColor: isEvenTile
                    ? scheme.onSurface
                    : scheme.surface,
                imageUrl:
                    'https://lh3.googleusercontent.com/a/ACg8ocJiOW7MX3yx9yEdIedMxgIEw3R5LtEMI_k2UOpH6xOqAKIHgkcHkg=s576-c-no',
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Sardaar Niamotullah',
                    style: TextUtils.paragraphBold(context),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        SvgPaths.locationCircle,
                        height: 10,
                        colorFilter: .mode(
                          scheme.onTertiary.withValues(alpha: .9),
                          .srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('Pabna', style: TextUtils.paragraphSmall(context)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              CrudConnectionButton(
                type: crudConnectionType,
                onTap: () {},
              ),
              if (crudConnectionType == .acceptRequest) ...[
                const SizedBox(width: 6),
                CrudConnectionButton(
                  type: .cancelRequest,
                  onTap: () {},
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
