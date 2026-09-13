import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';

class ImagePickedActions extends StatelessWidget {
  final ProfileMediaType mediaType;
  const ImagePickedActions({super.key, required this.mediaType});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formCubit = context.read<ProfileFormCubit>();
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            title: 'Cancel',
            textColor: scheme.onTertiary.withValues(alpha: .75),
            backgroundColorLeft: scheme.onSurface,
            backgroundColorRight: scheme.onSurface,
            onPressed: () {
              formCubit.discardPickedImage();
              context.pop();
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listenWhen: (_, curr) =>
                (curr is ProfileLoaded && curr.isUpdated) ||
                curr is ProfileFailure,
            listener: (context, _) {
              formCubit.discardPickedImage();
              context.pop();
            },
            builder: (context, state) {
              final formState = formCubit.state;
              final canUpload =
                  formState.savedProfile != null &&
                  formState.pickedImageFile != null;

              return PrimaryButton(
                title: 'Upload',
                isLoading: state is ProfileLoading,
                enable: canUpload,
                onPressed: () {
                  context.read<ProfileBloc>().add(
                    UpdateProfileMediaRequested(
                      profile: formState.savedProfile!,
                      picture: formState.pickedImageFile!,
                      mediaType: mediaType,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
