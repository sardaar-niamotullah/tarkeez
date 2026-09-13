import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/others/customer_care/bloc/customer_report_bloc.dart';
import 'package:tarkeez/features/others/customer_care/cubit/customer_report_form_cubit.dart';
import 'package:tarkeez/features/others/customer_care/data/models/customer_report_model.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomerCarePage extends StatefulWidget {
  const CustomerCarePage({super.key});

  @override
  State<CustomerCarePage> createState() => _CustomerCarePageState();
}

class _CustomerCarePageState extends State<CustomerCarePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileState = context.read<ProfileBloc>().state;
    final profile = profileState is ProfileLoaded ? profileState.profile : null;
    final mode = profile == null
        ? CustomerReportMode.guest
        : CustomerReportMode.authenticated;
    context.read<CustomerReportFormCubit>().setMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    final profileState = context.watch<ProfileBloc>().state;
    final profile = profileState is ProfileLoaded ? profileState.profile : null;

    final isGuest = profile == null;

    return BlocConsumer<CustomerReportBloc, CustomerReportState>(
      listener: (context, state) {
        if (state is CustomerReportSuccess) {
          context.read<CustomerReportFormCubit>().reset();
          showSuccessSnackBar(
            context,
            message: 'Your response has been successfully submitted.',
          );
          context.pop();
        }
        if (state is CustomerReportFailure) {
          showErrorSnackBar(context, message: state.message);
        }
      },
      builder: (context, reportState) {
        return BlocBuilder<CustomerReportFormCubit, CustomerReportFormState>(
          builder: (context, formState) {
            final cubit = context.read<CustomerReportFormCubit>();

            return StandAlonePageOuterStructure(
              title: texts.customerCare,
              actions: [ActionPageIcon(iconPath: SvgPaths.headset)],
              isLoading: reportState is CustomerReportLoading,

              bottomNavContent: Row(
                children: [
                  Expanded(
                    child: CancelButton(
                      enable:
                          formState.hasChanges &&
                          reportState is! CustomerReportLoading,
                      onPressed: () => cubit.reset(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      title: texts.submit,
                      isLoading: reportState is CustomerReportLoading,
                      enable: formState.canSubmit,
                      onPressed: () => cubit.submit(context, profile: profile),
                    ),
                  ),
                ],
              ),

              content: CustomScrollView(
                slivers: [
                  SliverList.list(
                    children: [
                      const SizedBox(height: 24),

                      Text(
                        texts.supportHeader,
                        style: TextUtils.title1(context, color: scheme.primary),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        texts.supportSubtext,
                        style: TextUtils.paragraph(context),
                      ),

                      const SizedBox(height: 24),

                      if (isGuest) ...[
                        Text(
                          texts.yourDetails,
                          style: TextUtils.title3(context),
                        ),
                        const SizedBox(height: 12),

                        CommonTextInput(
                          label: texts.nameLabel,
                          controller: cubit.nameController,
                          errorText: formState.nameError,
                          prefixIconPath: SvgPaths.user,
                        ),

                        const SizedBox(height: 16),

                        CommonTextInput(
                          label: texts.contactNumberLabel,
                          controller: cubit.phoneController,
                          errorText: formState.phoneError,
                          prefixIconPath: SvgPaths.phone,
                        ),

                        const SizedBox(height: 28),
                      ],

                      Text(
                        texts.describeIssue,
                        style: TextUtils.title3(context),
                      ),

                      const SizedBox(height: 12),

                      CommonTextInput(
                        label: texts.problemLabel,
                        maxLines: 4,
                        controller: cubit.reportController,
                        errorText: formState.reportError,
                        prefixIconPath: SvgPaths.penLine,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
