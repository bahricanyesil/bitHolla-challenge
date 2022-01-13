import 'package:flutter/material.dart';
import '../../../core/theme/text/l_text_theme.dart';

/// Text themes to use in the dark mode.
class LightTextTheme extends ITextTheme {
  /// Default [LightTextTheme] constructor.
  const LightTextTheme()
      : super(
          primaryTextColor: Colors.white,
          secondaryTextColor: const Color(0xff616161),
        );
}
