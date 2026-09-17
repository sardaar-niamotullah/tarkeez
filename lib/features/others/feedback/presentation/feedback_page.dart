import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return StandAlonePageOuterStructure(
      title: 'Feedback',
      actions: [ActionPageIcon(iconPath: SvgPaths.headset)],
      isLoading: false,

      bottomNavContent: Row(
        children: [
          Expanded(child: CancelButton(enable: true, onPressed: () {})),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              title: 'Submit',
              isLoading: false,
              enable: true,
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
                // controller: cubit.nameController,
                // errorText: formState.nameError,
                prefixIconPath: SvgPaths.user,
              ),
              const SizedBox(height: 16),

              CommonTextInput(
                label: 'Contact',
                // controller: cubit.phoneController,
                // errorText: formState.phoneError,
                prefixIconPath: SvgPaths.phone,
              ),
              const SizedBox(height: 28),

              Text('Describe issue', style: TextUtils.title3(context)),
              const SizedBox(height: 12),

              CommonTextInput(
                label: 'Problem',
                maxLines: 4,
                // controller: cubit.reportController,
                // errorText: formState.reportError,
                prefixIconPath: SvgPaths.penLine,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
