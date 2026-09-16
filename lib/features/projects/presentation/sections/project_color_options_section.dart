import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_color_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_color_selection_box.dart';

class ProjectColorOptionsSection extends StatelessWidget {
  final int? selectedColorId;
  final ValueChanged<int> onColorSelected;

  const ProjectColorOptionsSection({
    super.key,
    required this.selectedColorId,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = [
      ProjectColorModel(hexCode: '#123424', name: 'afawe', id: 1),
      ProjectColorModel(hexCode: '#123424', name: 'afawe', id: 1),
      ProjectColorModel(hexCode: '#123424', name: 'afawe', id: 1),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              SvgPaths.colorPalette,
              colorFilter: ColorFilter.mode(
                scheme.onTertiary.withValues(alpha: .9),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text('Select a color', style: TextUtils.title3(context)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const .all(ContainerDesignUtils.halfPadding),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Column(children: [_buildColorGrid(colors)]),
        ),
      ],
    );
  }

  Widget _buildColorGrid(List<ProjectColorModel> colors) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final c in colors)
          ProjectColorSelectionBox(
            color: c,
            isSelected: c.id == selectedColorId,
            onTap: () => onColorSelected(c.id),
          ),
      ],
    );
  }
}
