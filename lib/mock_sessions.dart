import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/database/app_database.dart';

class MockSessions extends StatefulWidget {
  const MockSessions({super.key});

  @override
  State<MockSessions> createState() => _MockSessionsState();
}

class _MockSessionsState extends State<MockSessions> {
  bool _isInserting = false;

  static const _projectIds = <String?>[
    null, // no project
    '891e3ebc-b548-4fb1-94c8-89f727c6d5a1',
    '7cfe93cb-509b-4f5f-87d4-9fe323f4280c',
    '4f3e2a65-87f6-4c5a-a8c1-65ac34a69814',
  ];

  Future<void> _insertMockSessions() async {
    setState(() => _isInserting = true);

    debugPrint('🟨 📀 mock session insert started');
    final stopwatch = Stopwatch()..start();
    final db = GetIt.I<AppDatabase>();
    final random = Random();

    final now = DateTime.now();
    final startDay = DateTime(now.year, now.month, now.day);

    const totalDays = 5000;
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

      // Split the exact daily total duration randomly
      // across all sessions.
      //
      // This guarantees:
      // - Exactly numSessions durations
      // - Every duration >= 0
      // - Sum of durations == totalDurationSeconds
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

        final projectId = _projectIds[random.nextInt(_projectIds.length)];

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
    return Positioned(
      bottom: 64,
      left: 16,
      child: FilledButton(
        onPressed: _isInserting ? null : _insertMockSessions,
        child: _isInserting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.storage),
      ),
    );
  }
}
