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
      listenWhen: (_, current) {
        final s = current.status;
        return s.isManual &&
            (s.phase == SyncPhase.failed || s.phase == SyncPhase.offline);
      },
      listener: (context, state) {
        final s = state.status;
        showErrorSnackBar(
          context,
          message: s.phase == SyncPhase.offline
              ? 'No internet connection. Try again when you are online.'
              : (s.message ?? 'Sync failed. Please try again.'),
        );
      },
      builder: (context, state) {
        return Container(
          // height: context.md ? 121 : null,
          // padding: const .all(ContainerDesignUtils.padding),
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
                    isLoading: false,
                    // backgroundColorRight: scheme.error,
                    // backgroundColorLeft: AppTheme.errorBright,
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
