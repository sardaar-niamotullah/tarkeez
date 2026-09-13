import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/avatar_circle.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';
import 'package:tarkeez/features/profile/data/models/profile_model.dart';
import 'package:tarkeez/features/profile/presentation/sections/update_profile_details_dialog.dart';
import 'package:tarkeez/features/profile/presentation/sections/user_info_section.dart';
import 'package:tarkeez/features/profile/presentation/sections/user_update_profile_media_bottom_sheet.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/user_cover_pic.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isOwnProfileHeader;
  const ProfileHeader({
    super.key,
    required this.profile,
    this.isOwnProfileHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formCubit = context.read<ProfileFormCubit>();
    final formState = context.watch<ProfileFormCubit>().state;
    return Stack(
      clipBehavior: .none,
      children: [
        UserCoverPic(
          imageUrl: profile.coverUrl,
          isEditable: isOwnProfileHeader,
          isLoading: context.select<ProfileBloc, bool>(
            (bloc) => bloc.state is ProfileLoading,
          ),
          localImageFile: formState.pickedMediaType == .cover
              ? formState.pickedImageFile
              : null,
          onTap: () =>
              showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: formCubit,
                  child: const UserUpdateProfileMediaBottomSheet(
                    mediaType: .cover,
                  ),
                ),
              ).then((_) {
                if (!formCubit.isClosed) formCubit.discardPickedImage();
              }),
        ),
        Padding(
          padding: const .only(top: 84),
          child: SizedBox(
            width: .infinity,
            child: Padding(
              padding: const .symmetric(
                horizontal: ContainerDesignUtils.radius,
              ),
              child: UserInfoSection(
                profile: profile,
                isOwnProfileInfo: isOwnProfileHeader,
              ),
            ),
          ),
        ),
        Positioned(
          top: 42,
          left: 24,
          child: AvatarCircle(
            radius: 48,
            innerRadius: 44,
            imageUrl: profile.avatarUrl,
            isEditable: isOwnProfileHeader,
            isLoading: context.select<ProfileBloc, bool>(
              (bloc) => bloc.state is ProfileLoading,
            ),
            localImageFile: formState.pickedMediaType == .avatar
                ? formState.pickedImageFile
                : null,
            onTap: () =>
                showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: formCubit,
                    child: const UserUpdateProfileMediaBottomSheet(
                      mediaType: .avatar,
                    ),
                  ),
                ).then((_) {
                  if (!formCubit.isClosed) formCubit.discardPickedImage();
                }),
          ),
        ),
        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Update profile details button
        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        if (isOwnProfileHeader)
          Positioned(
            top: 100,
            right: 36,
            child: ActionButton(
              iconPath: SvgPaths.penLine,
              backgroundColor: scheme.surface,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: formCubit,
                    child: const UpdateProfileDetailsDialog(),
                  ),
                ).then((_) {
                  if (!formCubit.isClosed) formCubit.reset();
                });
              },
            ),
          ),
      ],
    );
  }
}
