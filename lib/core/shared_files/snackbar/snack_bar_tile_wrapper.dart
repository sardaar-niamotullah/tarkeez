import 'package:tarkeez/core/shared_files/snackbar/snack_bar_tile.dart';
import 'package:flutter/material.dart';

class SnackBarTileWrapper extends StatefulWidget {
  final String? title;
  final String message;
  final String iconPath;
  final Color backgroundColor;
  final Color backgroundColorBright;
  final ColorScheme scheme;
  final double topPadding;
  final VoidCallback onDismiss;
  final Color textColor;
  final Color iconColor;

  const SnackBarTileWrapper({
    super.key,
    this.title,
    required this.message,
    required this.iconPath,
    required this.backgroundColor,
    required this.backgroundColorBright,
    required this.scheme,
    required this.topPadding,
    required this.onDismiss,
    required this.textColor,
    required this.iconColor,
  });

  @override
  State<SnackBarTileWrapper> createState() => _SnackBarTileWrapperState();
}

class _SnackBarTileWrapperState extends State<SnackBarTileWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  // ──────────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller.forward();
    Future.delayed(const Duration(seconds: 4), _dismiss);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // Animations
  // ──────────────────────────────────────────────
  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // ── Slides in from above the screen ────────────────────────────────
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  // ── Reverse animation then remove from overlay ─────────────────────
  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // ── Sit just below the status bar ──────────────────────────────
      top: widget.topPadding + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            // ── Swipe up to dismiss ─────────────────────────────────
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! < -200) {
                _dismiss();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: SnackBarTile(
                title: widget.title,
                message: widget.message,
                iconPath: widget.iconPath,
                iconColor: widget.iconColor,
                backgoundColor: widget.backgroundColor,
                backgoundColorBright: widget.backgroundColorBright,
                textColor: widget.textColor,
                scheme: widget.scheme,
                onClose: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
