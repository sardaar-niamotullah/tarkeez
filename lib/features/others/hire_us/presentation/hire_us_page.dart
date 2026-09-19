import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/others/hire_us/presentation/widgets/hiring_term_tile.dart';
import 'package:tarkeez/features/others/hire_us/presentation/widgets/tech_platfrom_card.dart';

class HireUsPage extends StatelessWidget {
  const HireUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return StandAlonePageOuterStructure(
      title: 'Make app',
      actions: [ActionPageIcon(iconPath: SvgPaths.appStore)],
      bottomNavContent: PrimaryButton(
        title: 'Form link',
        onPressed: () {},
        iconPath: SvgPaths.document,
      ),
      // ──────────────────────────────────────────────────────────
      // Body content.
      // ──────────────────────────────────────────────────────────
      content: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              const SizedBox(height: 16),
              // ──────────────────────────────────────────────
              // Intro
              // ──────────────────────────────────────────────
              Text(
                'Got a great app idea?',
                style: TextUtils.title2(context, color: scheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'We can provide you with an engineering team to turn your idea into reality.',
                style: TextUtils.title3(context),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisExtent: 90,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TechPlatfromCard(title: 'iOS', iconPath: SvgPaths.apple),
                  TechPlatfromCard(
                    title: 'Android',
                    iconPath: SvgPaths.androidBold,
                  ),
                  TechPlatfromCard(title: 'Desktop', iconPath: SvgPaths.laptop),
                  TechPlatfromCard(title: 'Web', iconPath: SvgPaths.globeBold),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Whether it’s iOS, Android, Desktop, or Web — we can build your app on any platform you choose.',
                style: TextUtils.paragraph(context),
                // textAlign: .center,
              ),
              const SizedBox(height: 16),

              // ──────────────────────────────────────────────
              // Desclimer
              // ──────────────────────────────────────────────
              Text(
                'However, due to our ethical and religious principles, we follow certain guidelines before taking on any project. These include:',
                style: TextUtils.paragraph(context),
              ),
              const SizedBox(height: 16),

              // ──────────────────────────────────────────────
              // Red signs
              // ──────────────────────────────────────────────
              HiringTermTile(
                title: 'No gambling',
                details: 'We do not work on apps that involve or promote any form of gambling.',
              ),
              HiringTermTile(
                title: 'No interest-based systems',
                details: 'We do not work on apps that involve interest (riba) or related financial systems.',
              ),
              HiringTermTile(
                title: 'No haram media',
                details: 'We do not work on apps that include or promote prohibited (haram) audio or video content.',
              ),
              HiringTermTile(
                title: 'No conflict with Islamic values',
                details: 'We do not work on apps that contradict Islamic principles or values.',
              ),
              const SizedBox(height: 8),

              // ──────────────────────────────────────────────
              // Pricing
              // ──────────────────────────────────────────────
              Text(
                'If your app idea meets the above criteria, we would be happy to work with you. Before proceeding, please review our minimum requirements:',
                style: TextUtils.paragraph(context),
              ),
              const SizedBox(height: 16),
              HiringTermTile(
                title: 'We charge \$10 per hour',
                isPricingCard: true,
                details: 'We primarily work on an hourly basis. A minimum of 50 hours must be purchased in advance once we mutually agree to proceed after the initial meeting.',
              ),
              const SizedBox(height: 8),
              Text(
                'Please note, A small to mid scale software project typically requires around 100–200 hours of work.',
                style: TextUtils.paragraph(context),
              ),
              const SizedBox(height: 16),
              HiringTermTile(
                title: 'Project or milestone-based pricing',
                isPricingCard: true,
                details: 'For well-defined projects, we can agree on a fixed project price or split the work into milestones, with pricing agreed upon for each milestone before development begins.',
              ),
              const SizedBox(height: 16),
              Text(
                'If you’re comfortable with the terms and pricing above, we’d love to hear about your project. Fill out the form below with a few details, and our team will get in touch if the project is a good fit and we have the availability to work on it.',
                style: TextUtils.paragraph(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
