import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────
// Mixin: manages hide/show animation driven by scroll direction.
// Apply to any State that owns a SingleTickerProviderStateMixin.
// ──────────────────────────────────────────────────────────────

mixin HideOnScrollMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  // ────── Config — override only if you need different values ──────
  double get buttonWidth => 168.0;
  double get peekWidth => 28.0;
  Duration get slideDuration => const Duration(milliseconds: 300);

  // ────── Internal state ────────────────────────────────────────
  late final AnimationController hideController;
  bool isHidden = false;

  // ──────────────────────────────────────────────────────────────
  // Computed animations
  // ──────────────────────────────────────────────────────────────

  // ────── Fraction of width to slide off-screen ────────────────
  late final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset((buttonWidth - peekWidth) / buttonWidth, 0.0),
  ).animate(CurvedAnimation(parent: hideController, curve: Curves.easeInOut));

  // ──────────────────────────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────────────────────────
  void initHideController() {
    hideController = AnimationController(vsync: this, duration: slideDuration);
  }

  void disposeHideController() => hideController.dispose();

  // ──────────────────────────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────────────────────────
  void hide() {
    if (isHidden) return;
    setState(() => isHidden = true);
    hideController.forward();
  }

  void show() {
    if (!isHidden) return;
    setState(() => isHidden = false);
    hideController.reverse();
  }
}
