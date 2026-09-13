import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/features/others/terms_and_conditions/presentation/widgets/terms_and_conditions_tile.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final terms = [
      AppTexts.of(context).terms1,
      AppTexts.of(context).terms2,
      AppTexts.of(context).terms3,
      AppTexts.of(context).terms4,
      AppTexts.of(context).terms5,
      AppTexts.of(context).terms6,
      AppTexts.of(context).terms7,
      AppTexts.of(context).terms8,
      AppTexts.of(context).terms9,
      AppTexts.of(context).terms10,
      AppTexts.of(context).terms11,
      AppTexts.of(context).terms12,
      AppTexts.of(context).terms13,
      AppTexts.of(context).terms14,
      AppTexts.of(context).terms15,
    ];
    return StandAlonePageOuterStructure(
      title: texts.termsAndConditions,
      actions: [ActionPageIcon(iconPath: SvgPaths.hammer)],
      content: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverList.builder(
            itemCount: terms.length,
            itemBuilder: (context, index) {
              return TermsAndConditionsTile(
                indexNumber: index,
                text: terms[index],
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
