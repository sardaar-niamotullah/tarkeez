import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_icon_button.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_picker_tile.dart';

class ProjectSelectionResult {
  final ProjectModel? project;
  const ProjectSelectionResult(this.project);
}

class PickProjectBottomSheet extends StatefulWidget {
  final ProjectModel? selectedProject;

  const PickProjectBottomSheet({super.key, this.selectedProject});

  @override
  State<PickProjectBottomSheet> createState() => _PickProjectBottomSheetState();
}

class _PickProjectBottomSheetState extends State<PickProjectBottomSheet> {
  int selectedIndex = 0;
  // bool _initialized = false;
  final projects = [
    ProjectModel(
      name: 'Some',
      colorId: 1,
      createdAt: DateTime(2025),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      contents: [
        SizedBox(
          height: 180,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextUtils.title1(context),
              ),
            ),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: selectedIndex,
              ),
              looping: projects.length > 3,
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: List.generate(projects.length + 1, (index) {
                if (index == projects.length) {
                  return ProjectPickerTile(index: index);
                }
                return ProjectPickerTile(
                  index: index,
                  project: projects[index],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryIconButton(
                iconPath: SvgPaths.editPen,
                onPressed: () {
                  context.pop();
                  // context.push(RouteNames.projectsPage);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                title: 'Done',
                onPressed: () {
                  final chosen = selectedIndex < projects.length
                      ? projects[selectedIndex]
                      : null;
                  context.pop(ProjectSelectionResult(chosen));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
