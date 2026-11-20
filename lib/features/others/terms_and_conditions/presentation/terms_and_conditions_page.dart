import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/info_tile.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = [
      'By downloading, installing, or using Tarkeez, you agree to these Terms and Conditions. If you do not agree with these terms, you should discontinue using the application.',

      'Tarkeez is provided on an "as-is" and "as-available" basis. We do not guarantee that the application, its features, cloud services, or any part of its functionality will remain continuously available, uninterrupted, error-free, or accessible at all times.',

      'Like any digital service, Tarkeez may become temporarily or permanently unavailable due to scheduled maintenance, technical difficulties, server failures, third-party service disruptions, security incidents, infrastructure changes, or other circumstances beyond our reasonable control. We are not obligated to maintain uninterrupted service or guarantee a specific level of availability.',

      'Purchasing a Premium package grants you access to the applicable Premium features for the stated subscription period, subject to these Terms and Conditions. It does not constitute a guarantee that the application or its services will remain operational, accessible, or compatible with your devices throughout that period. You acknowledge and accept these limitations before making a purchase.',

      'Before purchasing any Premium package, you are responsible for ensuring that Tarkeez works properly on your intended devices and operating systems. Compatibility may vary depending on device specifications, operating system versions, software configurations, and other technical factors. We do not guarantee compatibility with every device.',

      'Your data is backed up automatically whenever you\'re online, so you rarely need the Back Up button on the Profile tab. The button also works as a sync: use it to back up your latest sessions and to bring sessions recorded on another device to this one right away.',

      'Future application updates, operating system upgrades, security changes, device manufacturer modifications, or third-party dependency updates may affect the application\'s performance or compatibility. Such changes may cause certain features to malfunction or the application to become partially or entirely unusable on previously supported devices. We do not guarantee continued compatibility with older devices or software versions.',

      'We make reasonable efforts to protect and maintain user data; however, data loss, corruption, synchronization failures, or temporary or permanent loss of access may occur due to technical failures, device issues, software updates, server problems, or other unforeseen circumstances. You are responsible for maintaining any backups necessary to protect your important data.',

      'Premium packages are subject to the price, duration, features, and purchase conditions displayed at the time of purchase. Payments, renewals, cancellations, and refund eligibility are governed by the applicable app store policies and payment provider terms, together with applicable laws. Purchasing Premium does not guarantee compensation, an extension, or a refund for service interruptions, compatibility issues, maintenance, or discontinued features, except where required by applicable law.',

      'We reserve the right to modify, update, restrict, suspend, or discontinue any feature, service, or part of Tarkeez at our discretion, including for maintenance, technical, security, business, or operational reasons. These changes may occur even while you have an active Premium subscription. Purchasing a Premium package does not obligate us to maintain existing features, support every device, release future updates, or ensure the continued availability of any particular service throughout your subscription period.',

      'To the maximum extent permitted by applicable law, we disclaim liability for losses, damages, interruptions, or inconvenience resulting from application unavailability, device incompatibility, software changes, data loss, synchronization failures, or discontinued services. Nothing in these Terms excludes or limits liability that cannot legally be excluded or limited. These Terms may be updated from time to time, and continued use of Tarkeez constitutes acceptance of the updated terms where permitted by applicable law.',
    ];

    return StandAlonePageOuterStructure(
      title: 'Terms and conditions',
      actions: [ActionPageIcon(iconPath: AssetPaths.hammer)],
      content: SliverScrollMaxWidthBox(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverList.builder(
            itemCount: terms.length,
            itemBuilder: (context, index) {
              return InfoTile(indexNumber: index, text: terms[index]);
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
