import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TermsAndConditionsTile extends StatelessWidget {
  final int indexNumber;
  final String text;
  const TermsAndConditionsTile({
    super.key,
    required this.indexNumber,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const .only(bottom: 16),
      padding: const .symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: ContainerDesignUtils.allRadius,
        color: scheme.onSurface,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: scheme.surface,
          child: Center(
            child: Text(
              (indexNumber + 1).toString(),
              style: TextUtils.paragraphBold(context, color: scheme.primary),
            ),
          ),
        ),
        title: Text(text, style: TextUtils.paragraph(context)),
      ),
    );
  }
}
