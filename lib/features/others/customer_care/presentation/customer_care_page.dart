import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/others/customer_care/bloc/customer_report_bloc.dart';
import 'package:tarkeez/features/others/customer_care/cubit/customer_report_form_cubit.dart';
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
              title: 'Customer care',
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
                      title: 'Submit',
                      isLoading: reportState is CustomerReportLoading,
                      enable: formState.canSubmit,
                      onPressed: () {},
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
                        'We\'re here to help',
                        style: TextUtils.title1(context, color: scheme.primary),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'To let us know about the problem you are facing, kindly fill out the form below. Our support team will get back to you as soon as possible in case of need. In Shaa Allah.',
                        style: TextUtils.paragraph(context),
                      ),

                      const SizedBox(height: 24),

                      Text('Your details', style: TextUtils.title3(context)),
                      const SizedBox(height: 12),

                      CommonTextInput(
                        label: 'Name',
                        controller: cubit.nameController,
                        errorText: formState.nameError,
                        prefixIconPath: SvgPaths.user,
                      ),

                      const SizedBox(height: 16),

                      CommonTextInput(
                        label: 'Contact',
                        controller: cubit.phoneController,
                        errorText: formState.phoneError,
                        prefixIconPath: SvgPaths.phone,
                      ),

                      const SizedBox(height: 28),

                      Text('Describe issue', style: TextUtils.title3(context)),

                      const SizedBox(height: 12),

                      CommonTextInput(
                        label: 'Problem',
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
