import 'package:tarkeez/core/shared_files/cubits/language_cubit.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class LanguageSwitchButton extends StatelessWidget {
  final bool needInverseColor;
  const LanguageSwitchButton({super.key, this.needInverseColor = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (context, lang) {
        final languageCubit = context.read<LanguageCubit>();

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => languageCubit.switchLanguage(),
            borderRadius: ContainerDesignUtils.allRadius,

            // child: Container(
            //   padding: .all(4),
            //   decoration: BoxDecoration(
            //     color: scheme.tertiary,
            //     borderRadius: .circular(4),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       _buildIndividualButton(
            //         context,
            //         text: 'Eng',
            //         isActive: lang == AppLanguage.english,
            //       ),
            //       _buildIndividualButton(
            //         context,
            //         text: 'বাং',
            //         isActive: lang == AppLanguage.bangla,
            //       ),
            //     ],
            //   ),
            // ),
            child: _buildButton(
              context,
              text: lang == AppLanguage.bangla ? 'English' : 'বাংলা',
            ),
          ),
        );
      },
    );
  }

  //===============================================================
  // another language switch button design
  //===============================================================
  // ignore: unused_element
  Widget _buildIndividualButton(
    BuildContext context, {
    required String text,
    required bool isActive,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: .circular(4),
        border: .all(
          width: 1,
          color: isActive ? scheme.primary : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        style: TextUtils.paragraphSmallBold(
          context,
          color: isActive
              ? scheme.primary
              : needInverseColor
              ? AppTheme.white
              : scheme.onTertiary,
        ),
      ),
    );
  }

  //===============================================================
  // another language switch button design
  //===============================================================
  Widget _buildButton(BuildContext context, {required String text}) {
    final scheme = Theme.of(context).colorScheme;
    return Ink(
      width: 65,
      height: 20,
      padding: .symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: ContainerDesignUtils.allRadius,
        border: .all(
          width: 1,
          color: needInverseColor ? scheme.tertiary : scheme.onTertiary,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextUtils.paragraphSmallBold(
            context,
            color: needInverseColor ? scheme.tertiary : scheme.onTertiary,
          ),
        ),
      ),
    );
  }
}
