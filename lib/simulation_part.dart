import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/app_clock.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';
import 'package:tarkeez/simulate_sessions.dart';

class SimulationPart extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        const SimulateSessions(),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: 'Fake time',
                onPressed: () {
                  AppClock.fakeCurrentTime(
                    DateTime(2026, 9, 12, 03, 00),
                    speed: 60,
                  );
                  showSuccessSnackBar(
                    context,
                    message: '🕰️ fake time started',
                  );
                  Timer.periodic(const Duration(seconds: 1), (_) {
                    debugPrint(
                      '🕰️ fake clock: ${DateTimeFormatter.readableDateTime(AppClock.now())}',
                    );
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                title: 'Reset fake time',
                onPressed: () {
                  AppClock.reset();
                  showSuccessSnackBar(context, message: '🕰️ fake time reset');
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
