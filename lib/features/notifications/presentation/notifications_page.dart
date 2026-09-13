import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/features/notifications/presentation/widgets/notification_title.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final terms = [
      AppTexts.of(context).terms1,
      AppTexts.of(context).terms2,
      AppTexts.of(context).terms3,
      AppTexts.of(context).terms1,
      AppTexts.of(context).terms2,
      AppTexts.of(context).terms3,
      AppTexts.of(context).terms1,
      AppTexts.of(context).terms2,
      AppTexts.of(context).terms3,
      AppTexts.of(context).terms1,
      AppTexts.of(context).terms2,
      AppTexts.of(context).terms3,
    ];
    return StandAlonePageOuterStructure(
      title: texts.notifications,
      actions: [ActionPageIcon(iconPath: SvgPaths.letter)],
      content: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverList.builder(
            itemCount: terms.length,
            itemBuilder: (context, index) {
              return NotificationTitle(
                title:
                    'Qui consequat cupidatat sint aliqua ipsum aute minim fugiat ad sunt occaecat aliquip.',
                content: terms[index],
                isRead: index % 2 == 0,
              );
            },
          ),
        ],
      ),
    );
  }
}
