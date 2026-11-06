import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/timer_digits.dart';

class TodayTotalDurationDisplay extends StatelessWidget {
  const new({super.key, required this.isRunning, required this.colonVisible});

  final bool isRunning;
  final bool colonVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyRollupBloc, DailyRollupState>(
      builder: (context, state) {
        // Saved rows plus the running session, swapped in one emit when saved.
        final total = Duration(
          seconds: state is DailyRollupLoaded ? state.today : 0,
        );
        return TimerDigits(
          left: '${total.inHours}',
          right: '${total.inMinutes % 60}'.padLeft(2, '0'),
          dotsVisible: !isRunning || colonVisible,
        );
      },
    );
  }
}