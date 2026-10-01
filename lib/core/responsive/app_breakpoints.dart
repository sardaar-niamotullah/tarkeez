enum ScreenSize { xxs, xs, sm, md, lg, xl, xxl }

class AppBreakpoints {
  static const double xs = 480;
  static const double sm = 640;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;
  static const double xxl = 1536;

  static ScreenSize fromWidth(double width) {
    if (width >= xxl) return ScreenSize.xxl;
    if (width >= xl) return ScreenSize.xl;
    if (width >= lg) return ScreenSize.lg;
    if (width >= md) return ScreenSize.md;
    if (width >= sm) return ScreenSize.sm;
    if (width >= xs) return ScreenSize.xs;
    return ScreenSize.xxs;
  }
}
