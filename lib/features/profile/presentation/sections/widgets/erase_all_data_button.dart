import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class EraseAllDataButton extends StatefulWidget {
  const EraseAllDataButton({super.key, required this.isLocked});

  final bool isLocked;

  @override
  State<EraseAllDataButton> createState() => _EraseAllDataButtonState();
}

class _EraseAllDataButtonState extends State<EraseAllDataButton> {
  bool _isLoading = false;

  Future<void> _eraseAllData(BuildContext dialogContext) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final database = getIt<AppDatabase>();
      await Future.wait([
        database.projectsDao.deleteAllProjects(),
        database.sessionsDao.deleteAllSessions(),
      ]);
      getIt<ProjectBloc>().add(FetchProjectsRequested());
      getIt<SessionBloc>().add(FetchAllSessionsRequested());
      getIt<DailyRollupBloc>().add(FetchDailyRollupRequested());
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, message: e.toString());
    } finally {
      showSuccessSnackBar(
        context,
        message: 'Your data has been deleted. Welcome to a fresh start!',
      );
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(ContainerDesignUtils.padding),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Erase all data, and start fresh.',
            style: TextUtils.paragraphBold(context),
          ),
          SizedBox(
            width: 96,
            child: PrimaryButton(
              title: 'Erase',
              isLoading: _isLoading,
              onPressed: () {
                if (_isLoading) return;
                if (widget.isLocked) {
                  showDialog(
                    context: context,
                    builder: (_) => GoPremiumDialog(),
                  );
                  return;
                }
                showDialog(
                  context: context,
                  barrierDismissible: !_isLoading,
                  builder: (dialogContext) => StatefulBuilder(
                    builder: (dialogContext, setDialogState) => DeleteDialog(
                      isLoading: _isLoading,
                      onDeleteTap: () => _eraseAllData(dialogContext),
                      message:
                          'This will permanently delete all your Tarkeez data, including projects, sessions, and stats.\n\n'
                          'If you have a Premium subscription, it will remain active, so you can start fresh as a Premium member.',
                    ),
                  ),
                );
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
