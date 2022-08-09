import 'package:flutter/cupertino.dart';

/// Provides color palette for Vectura app.
abstract class VecColor {
  /// Primary color. Used for filled buttons.
  static const CupertinoDynamicColor primary =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xff001898),
    darkColor: Color(0xff00A7DC),
  );

  static const CupertinoDynamicColor primaryContrastingColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffAEAEAE),
    darkColor: Color(0xffCECECE),
  );

  static const CupertinoDynamicColor highlightColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffffffff),
    darkColor: Color(0xff000000),
  );

  static const CupertinoDynamicColor backgroud =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffF2F2F2),
    darkColor: Color(0xff181818),
  );

  static const CupertinoDynamicColor strong =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xff262626),
    darkColor: Color(0xffDCDCDC),
  );

  /// Color used for filled buttons that confirm actions and for success.
  static const Color confirm = CupertinoColors.activeGreen;

  // Color used for placeholder text
  static const CupertinoDynamicColor placeholderColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffAEAEAE),
    darkColor: Color(0xffCECECE),
  );

  static const Color darkGrey = Color(0xff262626);

  /// Color used for filled buttons that confirm destructive actions and for
  /// failure.
  static const Color danger = CupertinoColors.destructiveRed;

  static const Color transparent = Color(0x00000000);

  static Color primaryColor(BuildContext context) {
    return CupertinoDynamicColor.resolve(VecColor.primary, context);
  }

  static Color resolveColor(BuildContext context, Color color) {
    return CupertinoDynamicColor.resolve(color, context);
  }

  static const Color yellow = Color(0xFFF3BE00);
}
