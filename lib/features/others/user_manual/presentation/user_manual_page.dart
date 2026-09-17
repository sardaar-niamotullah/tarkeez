import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/features/others/terms_and_conditions/presentation/widgets/terms_and_conditions_tile.dart';

class UserManualPage extends StatelessWidget {
  const UserManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = ['dfawe', 'awefawef'];
    return StandAlonePageOuterStructure(
      title: 'User manual',
      actions: [ActionPageIcon(iconPath: SvgPaths.book)],
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
        ],
      ),
    );
  }
}
