enum ScreenSize { xs, sm, md, lg, xl }

class AppBreakpoints {
  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;

  static ScreenSize fromWidth(double width) {
    if (width >= xl) return ScreenSize.xl;
    if (width >= lg) return ScreenSize.lg;
    if (width >= md) return ScreenSize.md;
    if (width >= sm) return ScreenSize.sm;
    return ScreenSize.xs;
  }
}
