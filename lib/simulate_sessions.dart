import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';

class SimulateSessions extends StatefulWidget {
  const SimulateSessions({super.key});

  @override
  State<SimulateSessions> createState() => _SimulateSessionsState();
}

class _SimulateSessionsState extends State<SimulateSessions> {
  static const _minYears = 1;
  static const _maxYears = 50;
  static const _daysPerYear = 370;

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
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(popupContext).pop(),
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
      null, // no project
      if (projectState is ProjectLoaded)
        ...projectState.projects.map((p) => p.id),
    ];

    setState(() => _isInserting = true);

    debugPrint('🟨 📀 Simulate session insert started');
    final stopwatch = Stopwatch()..start();
    final db = GetIt.I<AppDatabase>();
    final random = Random();

    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day);
    final totalDays = _years * _daysPerYear;
    const batchSize = 2000;
    const dayMinutes = 24 * 60;
    const maxDailyDurationSeconds = 43_200; // 12 hours
    const lowDurationThresholdSeconds = 1_800; // 30 minutes

    var pending = <SessionsCompanion>[];
    var totalInserted = 0;

    Future<void> flush() async {
      if (pending.isEmpty) return;

      final chunk = pending;
      pending = [];

      await db.batch((b) {
        b.insertAll(db.sessions, chunk);
      });

      totalInserted += chunk.length;
    }

    for (var dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final dayStartLocal = startDay.subtract(Duration(days: dayOffset));

      // 30..50 sessions per day.
      final numSessions = 30 + random.nextInt(21);

      // 40% of days:
      //   total duration = 0..1799 seconds
      //
      // 60% of days:
      //   total duration = 1800..43200 seconds.
      final totalDurationSeconds = random.nextDouble() < 0.4
          ? random.nextInt(lowDurationThresholdSeconds)
          : lowDurationThresholdSeconds +
                random.nextInt(
                  maxDailyDurationSeconds - lowDurationThresholdSeconds + 1,
                );
      final cuts = List.generate(
        numSessions - 1,
        (_) => random.nextInt(totalDurationSeconds + 1),
      )..sort();
      final sessionDurations = <int>[];
      var previous = 0;
      for (final cut in cuts) {
        sessionDurations.add(cut - previous);
        previous = cut;
      }
      sessionDurations.add(totalDurationSeconds - previous);

      // Generate sessions throughout the day.
      for (var i = 0; i < numSessions; i++) {
        final sessionStartLocal = dayStartLocal.add(
          Duration(minutes: random.nextInt(dayMinutes)),
        );
        final durationSeconds = sessionDurations[i];
        final sessionEndLocal = sessionStartLocal.add(
          Duration(seconds: durationSeconds),
        );

        // Uniform random pick across null + all real project IDs.
        final projectId = projectIds[random.nextInt(projectIds.length)];

        pending.add(
          SessionsCompanion.insert(
            startedAt: sessionStartLocal.toUtc(),
            endedAt: sessionEndLocal.toUtc(),
            projectId: Value(projectId),
          ),
        );
        if (pending.length >= batchSize) {
          await flush();
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
