import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/sync/bloc/sync_bloc.dart';
import 'package:tarkeez/core/sync/sync_status.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class EraseAllDataButton extends StatelessWidget {
  const new({super.key, required this.isLocked});

  final bool isLocked;

  void _onErasePressed(BuildContext context) {
    if (isLocked) {
      showDialog(context: context, builder: (_) => GoPremiumDialog());
      return;
    }

    final syncBloc = context.read<SyncBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteDialog(
        message:
            'This will permanently delete all your Tarkeez data, including projects, sessions, and stats.\n\n'
            'If you have a Premium subscription, it will remain active, so you can start fresh as a Premium member.',
        onDeleteTap: () {
          // Navigator.of(dialogContext).pop();
          dialogContext.pop();
          syncBloc.add(const HistoryResetRequested());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<SyncBloc, SyncState>(
      // Only the answer to an erase.
      listenWhen: (_, current) => switch (current.status.phase) {
        SyncPhase.resetDone ||
        SyncPhase.resetFailed ||
        SyncPhase.resetOffline => true,
        _ => false,
      },
      listener: (context, state) {
        switch (state.status.phase) {
          case SyncPhase.resetDone:
            showSuccessSnackBar(
              context,
              message: 'All your data has been erased. You can start fresh.',
            );
          case SyncPhase.resetOffline:
            showErrorSnackBar(
              context,
              message:
                  'No internet connection. Connect to the internet and try again.',
            );
          default:
            showErrorSnackBar(
              context,
              message:
                  'Could not confirm the erase. Please check your connection and try again.',
            );
        }
      },
      builder: (context, state) {
        final isErasing = state.status.phase == SyncPhase.resetting;

        return Container(
          // height: context.md ? 121 : null,
          padding: const .symmetric(
            horizontal: ContainerDesignUtils.padding,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Erase all data, and start fresh.',
                style: TextUtils.paragraphBold(context),
              ),
              Column(
                mainAxisAlignment: .center,
                children: [
                  PrimaryButton(
                    title: 'Erase',
                    width: 96,
                    enable: !isErasing,
                    isLoading: isErasing,
                    backgroundColorRight: scheme.error,
                    backgroundColorLeft: AppTheme.errorBright,
                    onPressed: () => _onErasePressed(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}