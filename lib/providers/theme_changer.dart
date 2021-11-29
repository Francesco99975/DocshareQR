import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDark = true;

  ThemeChanger(this._currentTheme);

  ThemeData get theme => _currentTheme;

  bool get isDark => _isDark;

  setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  toggle() {
    if (_isDark) {
      _currentTheme = light;
      _isDark = false;
    } else {
      _currentTheme = dark;
      _isDark = true;
    }
    notifyListeners();
  }

  static const _fontFamily = "Dongle";

  static const _headline = TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
  static const _bodyText = TextStyle(fontSize: 18);

  static final ThemeData dark = ThemeData(
      backgroundColor: const Color.fromRGBO(22, 19, 19, 1),
      primaryColor: const Color.fromRGBO(255, 103, 0, 1),
      primaryColorDark: const Color.fromRGBO(147, 60, 2, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          headline1: _headline.copyWith(
              color: const Color.fromRGBO(255, 103, 0, 1),
              fontSize: 25,
              letterSpacing: 1.3),
          bodyText1:
              _bodyText.copyWith(color: const Color.fromRGBO(234, 224, 204, 1)),
          bodyText2:
              _bodyText.copyWith(color: const Color.fromRGBO(255, 103, 0, 1))),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromRGBO(0, 178, 202, 1),
          secondaryVariant: const Color.fromRGBO(36, 101, 109, 1)));

  static final ThemeData light = ThemeData(
      backgroundColor: const Color.fromRGBO(234, 224, 204, 1),
      primaryColor: const Color.fromRGBO(255, 103, 0, 1),
      primaryColorDark: const Color.fromRGBO(147, 60, 2, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          headline1: _headline.copyWith(
              color: const Color.fromRGBO(255, 103, 0, 1),
              fontSize: 22,
              letterSpacing: 1.3),
          bodyText1:
              _bodyText.copyWith(color: const Color.fromRGBO(22, 19, 19, 1)),
          bodyText2:
              _bodyText.copyWith(color: const Color.fromRGBO(255, 103, 0, 1))),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromRGBO(0, 178, 202, 1),
          secondaryVariant: const Color.fromRGBO(36, 101, 109, 1)));
}
