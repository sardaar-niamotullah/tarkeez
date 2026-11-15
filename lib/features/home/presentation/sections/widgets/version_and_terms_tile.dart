import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class VersionAndTermsTile extends StatefulWidget {
  const new({super.key});

  @override
  State<VersionAndTermsTile> createState() => _VersionAndTermsTileState();
}

class _VersionAndTermsTileState extends State<VersionAndTermsTile> {
  bool _isHovered = false;

  late final Future<PackageInfo> _packageInfo;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: CupertinoButton(
            onPressed: () => context.push(RouteNames.termsAndConditionsPage),
            padding: .zero,
            sizeStyle: .small,
            alignment: .centerLeft,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextUtils.paragraphSmallBold(
                context,
                color: _isHovered
                    ? scheme.onTertiary
                    : scheme.onTertiary.withValues(alpha: .5),
              ),
              child: const Text('Terms and conditions'),
            ),
          ),
        ),
        FutureBuilder<PackageInfo>(
          future: _packageInfo,
          builder: (context, snapshot) {
            final version = snapshot.data?.version;
            return Text(
              version == null ? '' : 'v$version',
              style: TextUtils.paragraphSmallBold(
                context,
                color: scheme.onTertiary.withValues(alpha: .5),
              ),
            );
          },
        ),
      ],
    );
  }
}
