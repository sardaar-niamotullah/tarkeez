import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';
import 'package:tarkeez/features/profile/data/models/dummy_profile.dart';
import 'package:tarkeez/features/profile/presentation/sections/personal_bests_section.dart';
import 'package:tarkeez/features/profile/presentation/sections/profile_header.dart';
import 'package:tarkeez/features/profile/presentation/sections/profile_rank_section.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/heatmap.dart';
import 'package:tarkeez/features/subscription/presentation/sections/subscription_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) {
        final cubit = ProfileFormCubit();
        final blocState = context.read<ProfileBloc>().state;
        if (blocState is ProfileLoaded) {
          cubit.populate(blocState.profile);
        } else if (blocState is ProfileFailure && blocState.profile != null) {
          cubit.populate(blocState.profile!);
        }
        return cubit;
      },
      child: Stack(
        children: [
          const Positioned.fill(child: HeroImageBackgroundLayer()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                CustomAppBar(
                  title: texts.profile,
                  isBackButtonEnabled: false,
                  actions: [ActionPageIcon(iconPath: SvgPaths.user)],
                ),
                Expanded(
                  child: BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileFailure) {
                        showErrorSnackBar(context, message: state.message);
                      }
                      if (state is ProfileLoaded) {
                        context.read<ProfileFormCubit>().populate(
                          state.profile,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          state is ProfileLoading || state is ProfileInitial;
                      final profile = switch (state) {
                        ProfileLoaded(:final profile) => profile,
                        ProfileFailure(:final profile) when profile != null =>
                          profile,
                        _ => DummyProfile.profile,
                      };

                      return Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          clipBehavior: .hardEdge,
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: ContainerDesignUtils.topRadius,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ProfileHeader(profile: profile),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const .symmetric(
                                          horizontal:
                                              ContainerDesignUtils.padding,
                                        ),
                                        child: const Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Heatmap(),
                                            SizedBox(height: 16),
                                            ProfileRankSection(),
                                            SizedBox(height: 16),
                                            PersonalBestsSection(
                                              isLocked: true,
                                            ),
                                            SizedBox(height: 16),
                                            SubscriptionCard(
                                              needToPopAppDrawer: false,
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
