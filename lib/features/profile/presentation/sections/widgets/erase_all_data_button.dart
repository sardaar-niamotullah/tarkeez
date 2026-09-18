import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class EraseAllDataButton extends StatelessWidget {
  const new({super.key, required this.isLocked});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: .all(ContainerDesignUtils.padding),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            'Erase all data, and start fresh.',
            style: TextUtils.paragraphBold(context),
          ),
          SizedBox(
            width: 96,
            child: PrimaryButton(
              title: 'Erase',
              onPressed: () {
                if (isLocked) {
                  showDialog(
                    context: context,
                    builder: (_) => GoPremiumDialog(),
                  );
                  return;
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteDialog(
                      onDeleteTap: () {},
                      message: 'This will permanently delete all your Tarkeez data, including projects, sessions, and stats. \n\nHowever, your Premium subscription will not be affected, so you can start fresh.',
                    ),
                  );
                }
              },
              backgroundColorLeft: AppTheme.errorBright,
              backgroundColorRight: scheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
