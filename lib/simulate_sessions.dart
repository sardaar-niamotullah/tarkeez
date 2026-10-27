import 'dart:math';

import 'package:drift/drift.dart' show Value;
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
    final db = GetIt.I<LocalDatabase>();
    final userId = db.currentUserId;
    final random = Random();
    final now = DateTime.now();
    final totalDays = _years * _daysPerYear;

    const batchSize = 2000;
    const maxDailyDurationSeconds = 43_200; // 12 hours
    const lowDurationThresholdSeconds = 1_800; // 30 minutes

    var pending = <LocalSessionsCompanion>[];
    var totalInserted = 0;

    Future<void> flush() async {
      if (pending.isEmpty) return;
      final chunk = pending;
      pending = [];
      await db.batch((b) {
        b.insertAll(db.localSessions, chunk);
      });
      totalInserted += chunk.length;
    }

    for (var dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      // Calendar days, so daylight saving never moves the start of the day.
      final dayStart = DateTime(now.year, now.month, now.day - dayOffset);
      final daySeconds = DateTime(
        now.year,
        now.month,
        now.day - dayOffset + 1,
      ).difference(dayStart).inSeconds;

      // 30..50 sessions per day.
      final numSessions = 30 + random.nextInt(21);

      // 40% of days: total = 0..1799 seconds.
      // 60% of days: total = 1800..43200 seconds.
      final totalDurationSeconds = random.nextDouble() < 0.4
          ? random.nextInt(lowDurationThresholdSeconds)
          : lowDurationThresholdSeconds +
                random.nextInt(
                  maxDailyDurationSeconds - lowDurationThresholdSeconds + 1,
                );

      // Split the day's total into session lengths.
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

      // Split the rest of the day into gaps, one before each session. The
      // sessions then follow each other and never overlap (the cloud would
      // drop overlapping ones).
      final gapCuts = List.generate(
        numSessions,
        (_) => random.nextInt(daySeconds - totalDurationSeconds + 1),
      )..sort();

      var cursor = 0; // seconds since the start of the day
      var previousGapCut = 0;
      for (var i = 0; i < numSessions; i++) {
        cursor += gapCuts[i] - previousGapCut;
        previousGapCut = gapCuts[i];

        final durationSeconds = sessionDurations[i];

        // A session must last at least 1 second.
        if (durationSeconds > 0) {
          final startLocal = dayStart.add(Duration(seconds: cursor));
          final endLocal = startLocal.add(Duration(seconds: durationSeconds));

          pending.add(
            LocalSessionsCompanion.insert(
              userId: userId,
              utcOffsetMinutes: startLocal.timeZoneOffset.inMinutes,
              startedAt: startLocal.toUtc(),
              endedAt: endLocal.toUtc(),
              projectId: Value(projectIds[random.nextInt(projectIds.length)]),
            ),
          );

          if (pending.length >= batchSize) await flush();
        }
        cursor += durationSeconds;
      }
    }

    await flush();

    stopwatch.stop();
    debugPrint(
      '🟨 📀 ⏱️ Total db writeup time: '
      '${stopwatch.elapsedMilliseconds}ms, '
      'inserted $totalInserted sessions',
    );

    // The rows went straight to the database, so tell the blocs to read again.
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
