import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/app/app_keys.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class ConnectivityUtils {
  static Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    final hasInterface = result.any((r) => r != ConnectivityResult.none);
    if (!hasInterface) return false;

    try {
      final response = await HttpClient()
          .getUrl(Uri.parse('https://www.gstatic.com/generate_204'))
          .timeout(const Duration(seconds: 5))
          .then((req) => req.close());
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  // Uses global key — no BuildContext needed
  static void showNoInternetSnackbar() {
    final messenger = AppKeys.scaffoldMessenger.currentState;
    if (messenger == null) return;

    final context = AppKeys.scaffoldMessenger.currentContext;
    if (context == null) return;

    final scheme = Theme.of(context).colorScheme;

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 255, 208, 99),
        padding: const .symmetric(vertical: 8),
        content: Row(
          mainAxisAlignment: .center,
          children: [
            const SizedBox(width: 16),
            SvgPicture.asset(
              SvgPaths.noInternet,
              height: 20,
              colorFilter: .mode(scheme.error, .srcIn),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'No internet connection',
                maxLines: 1,
                overflow: .ellipsis,
                style: TextUtils.paragraph(context, color: AppTheme.black),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        duration: const Duration(days: 365),
      ),
    );
  }

  static void hideNoInternetSnackbar() =>
      AppKeys.scaffoldMessenger.currentState?.hideCurrentSnackBar();
}
