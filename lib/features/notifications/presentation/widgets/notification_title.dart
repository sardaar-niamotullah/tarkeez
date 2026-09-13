import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class NotificationTitle extends StatelessWidget {
  final String title;
  final String content;
  final bool isRead;

  const NotificationTitle({
    super.key,
    required this.title,
    required this.content,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .only(top: 16, bottom: 16, left: 24, right: 8),
      margin: const .only(bottom: 16),
      decoration: BoxDecoration(
        color: isRead
            ? scheme.onSurface
            : scheme.secondaryContainer.withValues(alpha: .2),
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(title, style: TextUtils.title3(context)),
                const SizedBox(height: 8),
                Text(content, style: TextUtils.paragraph(context)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
          ),
        ],
      ),
    );
  }
}
