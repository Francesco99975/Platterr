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

  static const _fontFamily = "Poppins";

  static const _headline = TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
  static const _bodyText = TextStyle(fontSize: 18);

  static final ThemeData dark = ThemeData(
      backgroundColor: const Color.fromRGBO(20, 54, 66, 1),
      primaryColor: const Color.fromRGBO(15, 139, 141, 1),
      primaryColorDark: const Color.fromRGBO(3, 95, 96, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          headline1: _headline.copyWith(
            color: const Color.fromRGBO(35, 206, 107, 1),
          ),
          bodyText1:
              _bodyText.copyWith(color: const Color.fromRGBO(15, 139, 141, 1)),
          bodyText2:
              _bodyText.copyWith(color: const Color.fromRGBO(240, 162, 2, 1))),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromRGBO(240, 162, 2, 1),
          secondaryVariant: const Color.fromRGBO(175, 121, 15, 1)));

  static final ThemeData light = ThemeData(
      backgroundColor: const Color.fromRGBO(240, 239, 244, 1),
      primaryColor: const Color.fromRGBO(15, 139, 141, 1),
      primaryColorDark: const Color.fromRGBO(3, 95, 96, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          bodyText1:
              _bodyText.copyWith(color: const Color.fromRGBO(15, 139, 141, 1)),
          bodyText2:
              _bodyText.copyWith(color: const Color.fromRGBO(240, 162, 2, 1))),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromRGBO(240, 162, 2, 1),
          secondaryVariant: const Color.fromRGBO(175, 121, 15, 1)));
}
