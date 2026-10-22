import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/app_bar_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class CustomAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarLink,
    required this.actions,
    this.isBackButtonEnabled = true,
  });

  final String title;
  final String? subtitle, avatarLink;
  final List<Widget> actions;
  final bool isBackButtonEnabled;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
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
          if (isBackButtonEnabled)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                customBorder: const CircleBorder(),
                mouseCursor: SystemMouseCursors.click,
                child: Ink(
                  padding: .symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          if (!isBackButtonEnabled) SizedBox(width: 16),
          if (isBackButtonEnabled) const SizedBox(width: 0),
          Expanded(
            child: Padding(
              padding: const .only(top: 2),
              child: Text(
                title,
                style: TextUtils.title1Normal(context, color: AppTheme.white),
                overflow: .ellipsis,
              ),
            ),
          ),
          ...actions,
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
