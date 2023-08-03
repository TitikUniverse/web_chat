import 'package:flutter/material.dart';

import '../main.dart';
import 'inherited_my_theme.dart';
import 'themes_impl/my_theme_data.dart';
 
late final ValueNotifier<ThemeMode> _notifier;

ThemeMode activateNextTheme() {
  switch (_notifier.value) {
    case ThemeMode.light:
      _notifier.value = ThemeMode.dark;
      MyApp.prefs.setString('themeMode', ThemeMode.dark.name);
      return _notifier.value;
    case ThemeMode.dark:
      _notifier.value = ThemeMode.system;
      MyApp.prefs.setString('themeMode', ThemeMode.system.name);
      return _notifier.value;
    case ThemeMode.system:
      _notifier.value = ThemeMode.light;
      MyApp.prefs.setString('themeMode', ThemeMode.light.name);
      return _notifier.value;
  }
}
void initTheme(ThemeMode initThemeMode) {
  _notifier = ValueNotifier(initThemeMode);
}
ThemeMode currentAppTheme(BuildContext context) {
  if (_notifier.value == ThemeMode.system) return MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
  return _notifier.value;
}
String currentAppThemeAsString() {
  switch (_notifier.value) {
    case ThemeMode.dark:
      return 'Тёмная';
    case ThemeMode.light:
      return 'Светлая';
    case ThemeMode.system:
      return 'Системная';
  }
}
IconData getCurrentThemeIcon() {
  switch (_notifier.value) {
    case ThemeMode.dark:
      return Icons.wb_sunny_rounded;
    case ThemeMode.light:
      return Icons.nights_stay_rounded;
    case ThemeMode.system:
      return Icons.phone_android_rounded;
  }
}

class MyTheme extends StatelessWidget {
  final MyThemeData light;
  final MyThemeData dark;
  final Widget child;

  const MyTheme({super.key, required this.light, required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final systemThemeData = brightness == Brightness.light ? light : dark;

    MyThemeData _getMyThemeData(ThemeMode themeMode) {
      if (themeMode == ThemeMode.system) return systemThemeData;
      return themeMode == ThemeMode.light ? light : dark;
    }

    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (_, ThemeMode mode, __) {
        MyThemeData myThemeData = _getMyThemeData(mode);
        return InheritedMyTheme(
          data: myThemeData,
          child: Theme(
            data:myThemeData.themeData,
            child: child,
          ),
        );
      }
    );
  }
  static MyThemeData of(BuildContext context){
    final theme = Theme.of(context);
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyTheme>()!
        .data..themeData = theme;
  }
}