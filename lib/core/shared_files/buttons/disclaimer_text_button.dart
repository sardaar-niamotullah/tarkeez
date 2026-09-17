import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DisclaimerTextButton extends StatelessWidget {
  const DisclaimerTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return RichText(
      textAlign: .center,
      text: TextSpan(
        style: TextUtils.paragraphSmall(context, color: scheme.onTertiary),
        children: [
          TextSpan(text: 'By proceeding, you agree to our\n'),
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.baseline,
            child: GestureDetector(
              onTap: () => context.push(RouteNames.termsAndConditionsPage),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
                child: Text(
                  'Terms and conditions',
                  style: TextUtils.paragraphSmall(
                    context,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ).copyWith(height: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
