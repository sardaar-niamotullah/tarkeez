import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/app/user_data_reloader.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';

class SimulateSessions extends StatefulWidget {
  const new({super.key});

  @override
  State<SimulateSessions> createState() => _SimulateSessionsState();
}

class _SimulateSessionsState extends State<SimulateSessions> {
  static const _minYears = 1;
  static const _maxYears = 50;
  static const _daysPerYear = 370;

  static const _minGapSeconds = 180; // 3 minutes
  static const _minDailySessions = 30;
  static const _maxDailySessions = 50;
  static const _maxDailyDurationSeconds = 43200; // 12 hours
  static const _lowDurationThresholdSeconds = 1800; // 30 minutes

  bool _isInserting = false;
  int _years = _minYears;

  String _yearsLabel(int years) => years == 1 ? '1 year' : '$years years';

  Future<void> _showYearPicker() async {
    final controller = FixedExtentScrollController(
      initialItem: _years - _minYears,
    );

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground.resolveFrom(popupContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Align(
                  alignment: .centerRight,
                  child: CupertinoButton(
                    onPressed: () => Navigator.of(popupContext).pop(),
                    child: const Text('Done'),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      setState(() => _years = _minYears + index);
                    },
                    children: [
                      for (var y = _minYears; y <= _maxYears; y++)
                        Center(child: Text(_yearsLabel(y))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
  }

  Future<void> _insertSimulateSessions() async {
    final projectState = context.read<ProjectBloc>().state;

    final projectIds = <String?>[
      null,
      if (projectState is ProjectLoaded)
        ...projectState.projects.map((p) => p.id),
    ];

    setState(() => _isInserting = true);

    debugPrint('🟨 📀 Simulate session insert started');

    final stopwatch = Stopwatch()..start();
    final db = GetIt.I<LocalDatabase>();
    final random = Random();
    final now = DateTime.now();
    final totalDays = _years * _daysPerYear;

    const chunkSize = 1000;

    var pending = <({DateTime start, DateTime end, String? projectId})>[];
    var totalInserted = 0;

    Future<void> flush() async {
      if (pending.isEmpty) return;

      final chunk = pending;
      pending = [];

      await db.transaction(() async {
        for (final session in chunk) {
          await db.localSessionsDao.insertSession(
            startedAt: session.start,
            endedAt: session.end,
            utcOffsetMinutes: session.start.timeZoneOffset.inMinutes,
            projectId: session.projectId,
          );
        }
      });

      totalInserted += chunk.length;

      debugPrint('🟨 📀 inserted $totalInserted sessions so far');
    }

    for (var dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final dayStart = DateTime(now.year, now.month, now.day - dayOffset);

      final nextDayStart = DateTime(
        now.year,
        now.month,
        now.day - dayOffset + 1,
      );

      final daySeconds = nextDayStart.difference(dayStart).inSeconds;

      // Randomly select 30–50 sessions for this day.
      final requestedSessions =
          _minDailySessions +
          random.nextInt(_maxDailySessions - _minDailySessions + 1);

      // 40% of days: 0–29 minutes.
      // 60% of days: 30 minutes–12 hours.
      final requestedTotalDuration = random.nextDouble() < 0.4
          ? random.nextInt(_lowDurationThresholdSeconds)
          : _lowDurationThresholdSeconds +
                random.nextInt(
                  _maxDailyDurationSeconds - _lowDurationThresholdSeconds + 1,
                );

      // Every session needs at least one second, and every pair of
      // consecutive sessions needs a 180-second gap.
      //
      // Reduce the session count if the day cannot accommodate the
      // requested durations and minimum gaps.
      final maxSessionsByDay = max(
        1,
        (daySeconds + _minGapSeconds) ~/ (_minGapSeconds + 1),
      );

      final numSessions = min(requestedSessions, maxSessionsByDay);

      // Distribute the requested duration across sessions.
      // The total duration is capped to ensure that all sessions and
      // their required gaps can fit inside the calendar day.
      final availableDuration = max(
        0,
        daySeconds - (numSessions - 1) * _minGapSeconds,
      );

      final totalDurationSeconds = min(
        requestedTotalDuration,
        availableDuration,
      );

      // Split the daily duration into random session durations.
      final cuts = List.generate(
        numSessions - 1,
        (_) => random.nextInt(totalDurationSeconds + 1),
      )..sort();

      final sessionDurations = <int>[];
      var previousCut = 0;

      for (final cut in cuts) {
        sessionDurations.add(cut - previousCut);
        previousCut = cut;
      }

      sessionDurations.add(totalDurationSeconds - previousCut);

      // Sessions are generated chronologically. The gap is always
      // measured from the previous session's END.
      //
      // Start late enough in the day that all durations and gaps fit.
      final totalGapSeconds = (numSessions - 1) * _minGapSeconds;

      final totalOccupiedSeconds =
          sessionDurations.fold<int>(0, (sum, duration) => sum + duration) +
          totalGapSeconds;

      final maxStartOffset = max(0, daySeconds - totalOccupiedSeconds);

      var cursor = random.nextInt(maxStartOffset + 1);

      for (var i = 0; i < sessionDurations.length; i++) {
        final durationSeconds = sessionDurations[i];

        // Skip zero-length sessions.
        if (durationSeconds > 0) {
          final startLocal = dayStart.add(Duration(seconds: cursor));

          final endLocal = startLocal.add(Duration(seconds: durationSeconds));

          pending.add((
            start: startLocal,
            end: endLocal,
            projectId: projectIds[random.nextInt(projectIds.length)],
          ));

          if (pending.length >= chunkSize) {
            await flush();
          }

          cursor += durationSeconds;
        }

        // Reserve the mandatory 3-minute gap before the next session.
        if (i < sessionDurations.length - 1) {
          cursor += _minGapSeconds;
        }
      }
    }

    await flush();

    stopwatch.stop();

    debugPrint(
      '🟨 📀 ⏱️ Total db writeup time: '
      '${stopwatch.elapsedMilliseconds}ms, '
      'inserted $totalInserted sessions',
    );

    const UserDataReloader().reload();

    if (mounted) {
      setState(() => _isInserting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PrimaryButton(
            title: 'Simulate sessions',
            onPressed: _insertSimulateSessions,
            isLoading: _isInserting,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CupertinoButton(
            padding: const .symmetric(horizontal: 12, vertical: 8),
            onPressed: _isInserting ? null : _showYearPicker,
            child: Row(
              mainAxisSize: .min,
              children: [
                Text(_yearsLabel(_years)),
                const SizedBox(width: 4),
                const Icon(CupertinoIcons.chevron_up_chevron_down, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
