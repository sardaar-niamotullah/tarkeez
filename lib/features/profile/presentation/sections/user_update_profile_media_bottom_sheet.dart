import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/image_source_selectors.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/image_picked_actions.dart';

class UserUpdateProfileMediaBottomSheet extends StatelessWidget {
  final ProfileMediaType mediaType;
  const UserUpdateProfileMediaBottomSheet({super.key, required this.mediaType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      builder: (context, state) {
        final bool isImagePicked = state.pickedImageFile != null;
        return BottomSheetWrapper(
          contents: [
            BottomSheetTitleTile(
              title: isImagePicked ? 'Image selected' : 'Select source',
              iconPath: isImagePicked ? SvgPaths.upload : SvgPaths.gitBranch,
            ),
            const SizedBox(height: 24),

            if (isImagePicked) ...[
              // ThumbnailWidget(
              //   file: state.pickedImageFile!,
              //   onTap: () =>
              //       context.read<ProfileFormCubit>().discardPickedImage(),
              //   aspectRatio: mediaType == .avatar ? 1 : 3,
              //   alignment: mediaType == .avatar ? .center : .topCenter,
              // ),
              // const SizedBox(height: 24),
              ImagePickedActions(mediaType: mediaType),
            ],

            if (!isImagePicked)
              ImageSourceSelectors(
                onImagePicked: (file) => context
                    .read<ProfileFormCubit>()
                    .setPickedImage(file, mediaType),
              ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
