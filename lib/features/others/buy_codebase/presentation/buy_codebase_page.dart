import 'package:tarkeez/core/shared_files/buttons/bkash_payment_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/others/hire_us/presentation/widgets/hiring_term_tile.dart';
import 'package:tarkeez/features/others/hire_us/presentation/widgets/tech_platfrom_card.dart';

class BuyCodebasePage extends StatelessWidget {
  const BuyCodebasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final texts = AppTexts.of(context);

    return StandAlonePageOuterStructure(
      title: 'Buy codebase',
      actions: [ActionPageIcon(iconPath: SvgPaths.appStore)],
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
              const SizedBox(height: 8),
              Text(
                'We can provide you with an engineering team to turn your idea into reality.',
                style: TextUtils.title3(context),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  TechPlatfromCard(title: 'iOS', iconPath: SvgPaths.apple),
                  TechPlatfromCard(title: 'Web', iconPath: SvgPaths.globeBold),
                  TechPlatfromCard(
                    title: 'Android',
                    iconPath: SvgPaths.androidBold,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Align(
                alignment: .center,
                child: Text(
                  'Whether it’s Web, iOS, or Android — we can build your app on any platform you choose.',
                  style: TextUtils.paragraph(context),
                  textAlign: .center,
                ),
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
                details:
                    'We do not work on apps that involve or promote any form of gambling.',
              ),
              HiringTermTile(
                title: 'No interest-based systems',
                details:
                    'We do not work on apps that involve interest (riba) or related financial systems.',
              ),
              HiringTermTile(
                title: 'No haram media',
                details:
                    'We do not work on apps that include or promote prohibited (haram) audio or video content.',
              ),
              HiringTermTile(
                title: 'No conflict with Islamic values',
                details:
                    'We do not work on apps that contradict Islamic principles or values.',
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
                title: 'We charge ৳500 per hour',
                isPricingCard: true,
                details:
                    'We primarily work on an hourly basis. A minimum of 50 hours must be purchased in advance once we mutually agree to proceed after the initial meeting.',
              ),
              const SizedBox(height: 8),
              Text(
                'Please note, A small to mid scale software project typically requires around 100–200 hours of work. Kindly ensure your project scope and budget align before booking a paid consultation.',
                style: TextUtils.paragraph(context),
              ),
              const SizedBox(height: 16),

              // ──────────────────────────────────────────────
              // Initial meeting pricing
              // ──────────────────────────────────────────────
              RichText(
                text: TextSpan(
                  style: TextUtils.paragraph(context).copyWith(height: 1.2),
                  children: [
                    const TextSpan(
                      text:
                          'If you agree with the above conditions and pricing, you can book a ',
                    ),
                    TextSpan(
                      text: '30-minute',
                      style: TextUtils.paragraph(
                        context,
                        color: scheme.primary,
                      ).copyWith(height: 1.2),
                    ),
                    const TextSpan(text: ' video call with us for '),
                    TextSpan(
                      text: '৳500',
                      style: TextUtils.paragraph(
                        context,
                        color: scheme.primary,
                      ).copyWith(height: 1.2),
                    ),
                    const TextSpan(
                      text:
                          '.\n\nIf your project meets all our criteria but we decide not to proceed, you will receive a ',
                    ),
                    TextSpan(
                      text: '100%',
                      style: TextUtils.paragraph(
                        context,
                        color: scheme.primary,
                      ).copyWith(height: 1.2),
                    ),
                    const TextSpan(text: ' refund.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ──────────────────────────────────────────────
              // Contact number
              // ──────────────────────────────────────────────
              Text(
                'Provide your contact number and complete the payment to schedule a meeting. Our technical team will contact you shortly.',
                style: TextUtils.title3(context),
              ),
              const SizedBox(height: 16),
              CommonTextInput(
                label: texts.contactNumberLabel,
                hintText: texts.contactNumberHint,
                prefixIconPath: SvgPaths.phone,
              ),
              const SizedBox(height: 8),

              // ──────────────────────────────────────────────
              // Payment button
              // ──────────────────────────────────────────────
              BkashPaymentButton(
                title: 'Payment',
                backgroundColorLeft: scheme.primaryContainer,
                backgroundColorRight: scheme.primary,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
