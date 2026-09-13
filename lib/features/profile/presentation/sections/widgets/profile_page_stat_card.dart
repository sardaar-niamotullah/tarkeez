import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class ProfilePageStatCard extends StatelessWidget {
  final String title;
  final String value;
  const ProfilePageStatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 54,
      width: .infinity,
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            value,
            style: TextUtils.title1(context).copyWith(fontWeight: .bold),
          ),
          Text(
            title,
            style: TextUtils.paragraphSmall(
              context,
              color: scheme.onTertiary.withValues(alpha: .7),
            ).copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
