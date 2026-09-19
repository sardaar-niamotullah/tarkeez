import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return StandAlonePageOuterStructure(
      title: 'Feedback',
      actions: [ActionPageIcon(iconPath: SvgPaths.penLine)],
      isLoading: false,
      content: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              const SizedBox(height: 16),
              Container(
                padding: .all(ContainerDesignUtils.padding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topLeft,
                    end: .bottomRight,
                    colors: [
                      scheme.primaryContainer.withValues(alpha: .1),
                      scheme.primary.withValues(alpha: .1),
                    ],
                  ),
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Share your feedback',
                      style: TextUtils.title1(context, color: scheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your feedback matters to us. Whether it\'s a bug you\'ve noticed or an idea for improvement, your valuable feedback can help us understand what\'s working well and what needs to be improved.',
                      style: TextUtils.paragraph(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please take a moment to fill out the short form below.',
                      style: TextUtils.paragraph(context),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      title: 'Form link',
                      onPressed: () {},
                      iconPath: SvgPaths.document,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: .all(ContainerDesignUtils.padding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topLeft,
                    end: .bottomRight,
                    colors: [
                      AppTheme.fireTone.withValues(alpha: .1),
                      AppTheme.lightningGold.withValues(alpha: .1),
                    ],
                  ),
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Enjoying your experience?',
                      style: TextUtils.title1(context, color: scheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'We\'d really appreciate it if you could leave us a 5-star review on the App Store.',
                      style: TextUtils.paragraph(context),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          height: 36,
                          child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            scrollDirection: .horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) => SvgPicture.asset(
                              SvgPaths.starBold,
                              colorFilter: .mode(AppTheme.trophyGold, .srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      title: 'Review link',
                      onPressed: () {},
                      backgroundColorLeft: AppTheme.fireTone,
                      backgroundColorRight: AppTheme.secondary,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
