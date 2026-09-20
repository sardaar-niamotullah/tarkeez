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
    '9eb7d83c-ad27-4d2c-b53e-dd96d56575b0',
    '4b5d737c-c5e9-4dc7-9d5e-29d8f9f829cd',
    '573774aa-56d3-4ce6-beb1-d88263cfbed0',
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

    var pending = <SessionsCompanion>[];
    var totalInserted = 0;

    Future<void> flush() async {
      if (pending.isEmpty) return;
      final chunk = pending;
      pending = [];
      await db.batch((b) => b.insertAll(db.sessions, chunk));
      totalInserted += chunk.length;
    }

    for (var dayOffset = 0; dayOffset < totalDays; dayOffset++) {
      final dayStartLocal = startDay.subtract(Duration(days: dayOffset));
      final numSessions = 30 + random.nextInt(21); // 30..50
      final slotMinutes = dayMinutes / numSessions;

      var cursorMinutes = 0.0;
      for (var i = 0; i < numSessions; i++) {
        final durationMinutes =
            (slotMinutes * (0.4 + random.nextDouble() * 0.45)).clamp(
              3.0,
              slotMinutes - 1,
            );

        final sessionStartLocal = dayStartLocal.add(
          Duration(minutes: cursorMinutes.round()),
        );
        final sessionEndLocal = sessionStartLocal.add(
          Duration(minutes: durationMinutes.round()),
        );

        final projectId = _projectIds[random.nextInt(_projectIds.length)];

        pending.add(
          SessionsCompanion.insert(
            startedAt: sessionStartLocal.toUtc(),
            endedAt: sessionEndLocal.toUtc(),
            projectId: Value(projectId),
          ),
        );

        cursorMinutes += slotMinutes;
        if (pending.length >= batchSize) await flush();
      }
    }

    await flush();

    stopwatch.stop();
    debugPrint(
      '🟨 📀 ⏱️ Total db writeup time: ${stopwatch.elapsedMilliseconds}ms, '
      'inserted $totalInserted sessions',
    );

    if (mounted) setState(() => _isInserting = false);
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
