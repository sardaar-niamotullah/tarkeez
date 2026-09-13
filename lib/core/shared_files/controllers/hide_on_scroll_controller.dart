import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────
// Wraps a ScrollController and fires onScrollingUp(true/false)
// only when the offset delta exceeds [threshold].
// ──────────────────────────────────────────────────────────────

class HideOnScrollController {
  HideOnScrollController({required this.onScrollingUp, this.threshold = 2.0}) {
    scrollController = ScrollController()..addListener(_onScroll);
  }

  final void Function(bool scrollingUp) onScrollingUp;
  final double threshold;

  late final ScrollController scrollController;

  double _lastOffset = 0;

  // ────── Scroll listener ───────────────────────────────────────
  void _onScroll() {
    final current = scrollController.offset;
    if ((current - _lastOffset).abs() < threshold) return;
    onScrollingUp(current > _lastOffset);
    _lastOffset = current;
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }
}
