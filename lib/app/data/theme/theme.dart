import 'package:flutter/material.dart';

class Themes {
  final ThemeData lightTheme = ThemeData(
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFFFFFFFF),
      elevation: 5,
      // shape: AutomaticNotchedShape(ShapeBorder)
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(240, 240, 240, 1),
    primaryIconTheme: const IconThemeData(color: Colors.white),
    primaryColor: const Color(0xFF4E1A37),
    primaryColorDark: Colors.blue,
    primarySwatch: Colors.lightBlue,
    accentColor: Colors.cyanAccent,
    cardColor: const Color(0xFFFFFFFF),
    iconTheme: const IconThemeData(color: Colors.black),
    // canvasColor: Color.fromRGBO(86, 194, 255, 1),
    canvasColor: Colors.transparent,
    bottomAppBarColor: Colors.transparent,
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.withOpacity(.2)),
    secondaryHeaderColor: Colors.deepPurpleAccent,
    fontFamily: 'Raleway',
    textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        bodyText2: const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
        caption: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),

        //Used for item subtitle
        subtitle1: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontFamily: 'RobotoCondensed',
            height: 1.6),

        //This is used for appbar titles
        headline6: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'RobotoCondensed',
        )),
  );

  static final ThemeData darkTheme = ThemeData.dark();
}
