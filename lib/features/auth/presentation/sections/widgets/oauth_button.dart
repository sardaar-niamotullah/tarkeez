import 'package:tarkeez/core/app/user_data_reloader.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:go_router/go_router.dart';

class OauthButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthSuccess) {
          const UserDataReloader().reload();
          context.go(RouteNames.home);
        }
        if (authState is AuthFailure) {
          showErrorSnackBar(context, message: authState.message);
        }
      },
      builder: (context, authState) {
        final isLoading = authState is AuthLoading;

        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () => context.read<AuthBloc>().add(GoogleSignInRequested()),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: .zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: ContainerDesignUtils.allRadius,
            ),
          ),
          child: Ink(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: ContainerDesignUtils.allRadius,
              gradient: LinearGradient(
                begin: .centerLeft,
                end: .centerRight,
                colors: [AppTheme.black, scheme.primary],
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppTheme.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: .center,
                      children: [
                        SvgPicture.asset(SvgPaths.google, height: 18),
                        const SizedBox(width: 16),
                        Text(
                          'Continue with Google',
                          style: TextUtils.title3(
                            context,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
