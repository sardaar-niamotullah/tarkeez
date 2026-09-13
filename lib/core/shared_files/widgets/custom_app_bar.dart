import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String? subtitle, avatarLink;
  final List<Widget> actions;
  final bool isBackButtonEnabled;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarLink,
    required this.actions,
    this.isBackButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isBackButtonEnabled)
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: AppTheme.white),
          ),
        if (!isBackButtonEnabled) const SizedBox(height: 48, width: 16),
        if (isBackButtonEnabled) const SizedBox(width: 0),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: TextUtils.title1Normal(context, color: AppTheme.white),
                overflow: .ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  overflow: .ellipsis,
                  style: TextUtils.paragraph(context, color: AppTheme.white),
                ),
            ],
          ),
        ),
        ...actions,
        // SizedBox(width: isBackButtonEnabled ? 16 : 0),
        const SizedBox(width: 16),
      ],
    );
  }
}
