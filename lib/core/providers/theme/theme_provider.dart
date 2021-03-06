import 'package:flutter/material.dart';

import '../../../product/managers/local-storage/settings/settings_local_manager.dart';
import '../../../product/theme/dark_theme.dart';
import '../../../product/theme/light_theme.dart';
import '../../constants/enums/settings-enums/app_themes.dart';
import '../../constants/enums/settings-enums/settings_storage_keys.dart';
import '../../extensions/enum/enum_extensions.dart';
import '../../extensions/string/type_conversion_extensions.dart';

/// Provider of theme, manages theme actions.
class ThemeProvider extends ChangeNotifier {
  ThemeData? _theme;
  AppThemes _themeEnum = AppThemes.light;

  /// Gets the value of current theme as [AppThemes] enum.
  AppThemes get currenThemeEnum => _themeEnum;

  /// Gets the current theme as [ThemeData].
  ThemeData get currentTheme {
    if (_theme == null) _getStoredTheme();
    return _theme!;
  }

  void _getStoredTheme() {
    final AppThemes? storedTheme = SettingsLocalManager.instance
        .get(SettingsStorageKeys.appTheme)
        ?.toEnum<AppThemes>(AppThemes.values);
    if (storedTheme != null) _themeEnum = storedTheme;
    _assignTheme(_themeEnum);
  }

  void _assignTheme(AppThemes themeEnum) {
    if (themeEnum == AppThemes.dark) {
      _theme = DarkTheme().createTheme;
    } else if (themeEnum == AppThemes.light) {
      _theme = LightTheme().createTheme;
    }
  }

  /// Sets the current theme to the given one.
  Future<void> setTheme(AppThemes themeEnum) async {
    _assignTheme(themeEnum);
    _themeEnum = themeEnum;
    await SettingsLocalManager.instance
        .set(SettingsStorageKeys.appTheme, _themeEnum.value);
    notifyListeners();
  }

  /// Switches between the light-dark themes.
  Future<void> switchTheme() async {
    if (_themeEnum == AppThemes.light) {
      await setTheme(AppThemes.dark);
    } else if (_themeEnum == AppThemes.dark) {
      await setTheme(AppThemes.light);
    }
  }

  /// Returns a bool that represents whether the current theme is dark.
  bool get isDark => _themeEnum == AppThemes.dark;
}
