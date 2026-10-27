import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/sync/bloc/sync_bloc.dart';
import 'package:tarkeez/core/sync/sync_status.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SyncButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<SyncBloc, SyncState>(
      // Only the answer to a Sync tap. Background syncs and the erase stay silent.
      listenWhen: (_, current) {
        final s = current.status;
        return s.isManual &&
            (s.phase == SyncPhase.succeeded ||
                s.phase == SyncPhase.failed ||
                s.phase == SyncPhase.offline);
      },
      listener: (context, state) {
        final s = state.status;
        switch (s.phase) {
          case SyncPhase.succeeded:
            showSuccessSnackBar(context, message: 'Everything is up to date.');
          case SyncPhase.offline:
            showErrorSnackBar(
              context,
              message: 'No internet connection. Try again when you are online.',
            );
          case SyncPhase.failed:
            showErrorSnackBar(
              context,
              message: s.message ?? 'Sync failed. Please try again.',
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        final isSyncing = state.status.phase == SyncPhase.syncing;

        return Container(
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
                'Sync data to cloud.',
                style: TextUtils.paragraphBold(context),
              ),
              Column(
                mainAxisAlignment: .center,
                children: [
                  PrimaryButton(
                    title: 'Sync',
                    width: 96,
                    // Also disabled while an erase is running.
                    enable: !state.status.isBusy,
                    isLoading: isSyncing,
                    onPressed: () =>
                        context.read<SyncBloc>().add(const SyncButtonPressed()),
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