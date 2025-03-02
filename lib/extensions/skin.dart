import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_fractal/themes/fractal.dart';
import 'package:flutter/services.dart';
import 'package:fractal_flutter/index.dart';

extension FractalSknExt on FractalSkin {
  static String font1 = "Roboto";
  //Color get primary => Colors.purple;

  Color get c => color.toMaterial;
  ThemeData theme(bool dark) {
    final scheme = ColorScheme.fromSeed(seedColor: c);
    final buttonStyle = ButtonStyle(
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 8),
      ),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
    return ThemeData(
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: font1,
      //iconTheme: IconThemeData(color: color),
      //scaffoldBackgroundColor: white,
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: _wb(dark),
        //indicatorColor: _wb(!dark).withAlpha(200),
        //   labelColor: _wb(!dark),
        tabAlignment: TabAlignment.center,
        dividerHeight: 0,
      ),
      //primaryColor: c,
      //primarySwatch: c,
      indicatorColor: scheme.primary,

      useMaterial3: true,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: _wb(!dark),
        backgroundColor: scheme.primary,
      ),
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: !dark
          ? const Color.fromARGB(255, 250, 250, 250)
          : const Color.fromARGB(255, 36, 40, 41),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        //filled: true,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
        ),
        //filled: true,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                6,
              ),
            ),
          ),
          //iconColor: WidgetStatePropertyAll<Color>(scheme.primary),
          textStyle: MaterialStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: states.contains(MaterialState.pressed) ? 24 : 20,
              color: _wb(dark),
            ),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: buttonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: buttonStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: buttonStyle,
      ),
      appBarTheme: const AppBarTheme(
        //iconTheme: IconThemeData(color: white.toMaterial),
        //surfaceTintColor: Colors.white,
        //shadowColor: Colors.black.withAlpha(64),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
    );
  }

  /*
  TextTheme get fallbackTextTheme => TextTheme(
        bodyText1: fallbackTextStyle,
        bodyText2: fallbackTextStyle,
        button: fallbackTextStyle,
        caption: fallbackTextStyle,
        overline: fallbackTextStyle,
        headline1: fallbackTextStyle,
        headline2: fallbackTextStyle,
        headline3: fallbackTextStyle,
        headline4: fallbackTextStyle,
        headline5: GoogleFonts.fredoka(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: black.toMaterial.withAlpha(160),
              offset: const Offset(4, 4),
              blurRadius: 12,
            ),
          ],
        ),
        headline6: fallbackTextStyle,
        subtitle1: fallbackTextStyle,
        subtitle2: fallbackTextStyle,
      );
      */
  Color _wb(bool dark) => (dark ? white : black).toMaterial;
  //the light theme

  static const fallbackTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontFamilyFallback: ['NotoEmoji'],
  );

  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isCupertinoStyle => isIOS || isMacOS;

  static bool get isMobile => isAndroid || isIOS;

  /// For desktops which don't support ChachedNetworkImage yet
  static bool get isBetaDesktop => isWindows || isLinux;

  static bool get isDesktop => isLinux || isWindows || isMacOS;

  static bool get usesTouchscreen => !isMobile;

  static bool get platformCanRecord => (isMobile || isMacOS);

  static String get clientName =>
      'fractal ${isWeb ? 'web' : Platform.operatingSystem}${kReleaseMode ? '' : 'Debug'}';
}
