import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData greenFinanceTheme = ThemeData(
    primaryColor: const Color(0xFF4CAF50),
    primaryColorLight: const Color(0xFFC8E6C9),
    primaryColorDark: const Color(0xFF087F23),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF81C784),
      error: Color(0xFFD32F2F),
      surface: Color(0xFFF1F8E9),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Roboto',
      ), // Encabezado grande
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Roboto',
      ), // Títulos intermedios
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color(0xFF087F23),
        fontFamily: 'Roboto',
      ), // Texto principal
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.black54,
        fontFamily: 'Roboto',
      ),
      bodySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: 'Roboto',
      ), // Subtítulos o contenido menos relevante
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF1F8E9),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF4CAF50)),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF087F23), width: 2.0),
      ),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // Iconos
    iconTheme: const IconThemeData(color: Color(0xFF087F23)),

    // Divisores y bordes
    dividerColor: const Color(0xFFBDBDBD),
  );

  static final ThemeData greenFinanceDarkTheme = ThemeData(
    // Colores principales
    primaryColor: Color.fromARGB(255, 183, 23, 76), // kButtonPrimary
    primaryColorLight: Color.fromRGBO(195, 32, 86, 1), // kpurpleOn
    primaryColorDark: Color(0xFFC63959), // kpurpleOff

    scaffoldBackgroundColor: Color.fromARGB(
      255,
      17,
      17,
      17,
    ), // kBackgroundColor

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFC63959), // kButtonPrimary
      secondary: Color(0xFFC63959), // kButtonSecondary
      error: Color(0xFFD32F2F),
      surface: Color.fromARGB(255, 17, 17, 17), // kDarkGray
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Roboto',
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Roboto',
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color.fromARGB(174, 139, 5, 50), // kButtonSecondary
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
        fontFamily: 'Roboto',
      ),
      bodySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
        fontFamily: 'Roboto',
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFC63959), // kButtonPrimary
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 37, 37, 37), // kGray
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFC63959)), // kButtonPrimary
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(116, 12, 46, 1),
          width: 2.0,
        ), // kpurpleOff
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 17, 17, 17), // kDarkGray
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    iconTheme: const IconThemeData(
      color: Colors.white, // kButtonPrimary
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFC63959),
      foregroundColor: Colors.white, // ← ícono blanco también aquí
    ),
  );
}
