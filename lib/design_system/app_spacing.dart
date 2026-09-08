abstract final class AppSpacing {
  // Base unit: 4px
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Component-specific
  static const double cardPadding = 16;
  static const double screenPadding = 16;
  static const double buttonPaddingH = 24;
  static const double buttonPaddingV = 12;
  static const double listItemSpacing = 8;
  static const double sectionSpacing = 32;
}

abstract final class AppBorderRadius {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 999;
}

abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 6;
}
