import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.deepPurpleAccent,
    canvasColor: Colors.deepPurpleAccent,

    //app bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurpleAccent,
      titleTextStyle: TextStyle(
          color: Colors.white, fontFamily: 'PoppinsSemiBold', fontSize: 21),
    ),

    //text color
    textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontFamily: 'PoppinsBold', fontSize: 23, color: Colors.white),
      //
      displayLarge: TextStyle(
          fontFamily: 'PoppinsBold', fontSize: 18, color: Colors.black),
      displayMedium: TextStyle(
          fontFamily: 'PoppinsBold',
          fontSize: 19,
          color: Colors.deepPurpleAccent),
      displaySmall:
          TextStyle(fontFamily: 'Poppins', fontSize: 17, color: Colors.black),
      //
      bodyMedium: TextStyle(
          fontFamily: 'PoppinsBold', fontSize: 18, color: Colors.black),
      bodyLarge: TextStyle(
          fontFamily: 'PoppinsSemiBold', fontSize: 17, color: Colors.black),
      bodySmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontFamily: 'PoppinsBold',
        fontSize: 12,
        color: Colors.black,
      ),
    ),

    //sahdow color
    shadowColor: Colors.grey[300],

    //splash
    splashColor: Colors.grey[200],

    //focus
    focusColor: Colors.deepPurple[100],
    //higlighting
    highlightColor: Colors.deepPurpleAccent[100],

    //hint
    hintColor: Colors.grey[400],
    colorScheme: const ColorScheme.dark(
      background: Colors.white,
      primary: Colors.deepPurpleAccent,
      secondary: Colors.white,
      onSurface: Colors.black,
      onPrimary: Colors.black,
    ),

    //snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.deepPurpleAccent,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'PoppinsSemiBold',
      ),
    ));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.grey[800],
  canvasColor: Colors.deepPurpleAccent,

  //app bar theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    titleTextStyle: const TextStyle(
        color: Colors.white, fontFamily: 'PoppinsSemiBold', fontSize: 21),
  ),

  //text color
  textTheme: const TextTheme(
    titleMedium:
        TextStyle(fontFamily: 'PoppinsBold', fontSize: 23, color: Colors.white),
    //
    displayLarge:
        TextStyle(fontFamily: 'PoppinsBold', fontSize: 18, color: Colors.white),
    displayMedium: TextStyle(
        fontFamily: 'PoppinsBold',
        fontSize: 19,
        color: Colors.deepPurpleAccent),
    displaySmall:
        TextStyle(fontFamily: 'Poppins', fontSize: 17, color: Colors.white),
    //
    bodyMedium:
        TextStyle(fontFamily: 'PoppinsBold', fontSize: 18, color: Colors.white),
    bodyLarge: TextStyle(
        fontFamily: 'PoppinsSemiBold', fontSize: 17, color: Colors.white),
    bodySmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontFamily: 'PoppinsBold',
      fontSize: 12,
      color: Colors.white,
    ),
  ),

  //sahdow color
  shadowColor: Colors.grey[900],

  //splash
  splashColor: Colors.grey[900],

  //hint
  hintColor: Colors.grey[400],

  //focus
  focusColor: Colors.grey[400],

  //higlighting
  highlightColor: Colors.grey[600],

  //
  colorScheme: ColorScheme.dark(
    background: Colors.white,
    primary: Colors.grey[900]!,
    secondary: const Color.fromARGB(255, 47, 47, 47),
    onSurface: Colors.white,
    onPrimary: Colors.white,
  ),

  //snackbar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'PoppinsSemiBold',
    ),
  ),
);
