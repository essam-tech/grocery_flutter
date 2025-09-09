import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/local/my_shared_pref.dart';
import 'dark_theme_colors.dart';
import 'light_theme_colors.dart';
import 'my_styles.dart';

class MyTheme {
  static ThemeData getThemeData({required bool isLight}) {
    final brightness = isLight ? Brightness.light : Brightness.dark;

    // تعريف الـ ColorScheme بشكل صحيح مع الـ brightness
    final colorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.green, // ممكن تغير حسب اللون الرئيسي
      brightness: brightness,
    ).copyWith(
      secondary: isLight ? LightThemeColors.accentColor : DarkThemeColors.accentColor,
      background: isLight ? LightThemeColors.backgroundColor : DarkThemeColors.backgroundColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,
      primaryColorLight: isLight ? LightThemeColors.primaryColorLight : DarkThemeColors.primaryColorLight,
      primaryColorDark: isLight ? LightThemeColors.primaryColorDark : DarkThemeColors.primaryColorDark,
      canvasColor: isLight ? LightThemeColors.canvasColor : DarkThemeColors.canvasColor,
      cardColor: isLight ? LightThemeColors.cardColor : DarkThemeColors.cardColor,
      hintColor: isLight ? LightThemeColors.hintTextColor : DarkThemeColors.hintTextColor,
      dividerColor: isLight ? LightThemeColors.dividerColor : DarkThemeColors.dividerColor,
      scaffoldBackgroundColor: isLight ? LightThemeColors.scaffoldBackgroundColor : DarkThemeColors.scaffoldBackgroundColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,
      ),
      appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),
      elevatedButtonTheme: MyStyles.getElevatedButtonTheme(isLightTheme: isLight),
      textTheme: MyStyles.getTextTheme(isLightTheme: isLight),
      chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),
      iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),
      colorScheme: colorScheme,
    );
  }

  static changeTheme() {
    bool isLightTheme = MySharedPref.getThemeIsLight();
    MySharedPref.setThemeIsLight(!isLightTheme);
    Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  bool get getThemeIsLight => MySharedPref.getThemeIsLight();
}
  getThemeData({required bool isLight}){
    return ThemeData(
        useMaterial3: true,
        // main color (app bar,tabs..etc)
        primaryColor: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,
        primaryColorLight: isLight ? LightThemeColors.primaryColorLight : DarkThemeColors.primaryColorLight,
        primaryColorDark: isLight ? LightThemeColors.primaryColorDark : DarkThemeColors.primaryColorDark,
        // color contrast (if the theme is dark text should be white for example)
        brightness: isLight ? Brightness.light : Brightness.dark,
        // canvas Color
        canvasColor: isLight ? LightThemeColors.canvasColor : DarkThemeColors.canvasColor,
        // card widget background color
        cardColor: isLight ? LightThemeColors.cardColor : DarkThemeColors.cardColor,
        // hint text color
        hintColor: isLight ? LightThemeColors.hintTextColor : DarkThemeColors.hintTextColor,
        // divider color
        dividerColor: isLight ? LightThemeColors.dividerColor : DarkThemeColors.dividerColor,
        scaffoldBackgroundColor: isLight ? LightThemeColors.scaffoldBackgroundColor : DarkThemeColors.scaffoldBackgroundColor,

        // progress bar theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,
        ),

        // appBar theme
        appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

        // elevated button theme
        elevatedButtonTheme: MyStyles.getElevatedButtonTheme(isLightTheme: isLight),

        // text theme
        textTheme: MyStyles.getTextTheme(isLightTheme: isLight),

        // chip theme
        chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),

        // icon theme
        iconTheme: MyStyles.getIconTheme(isLightTheme: isLight), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: isLight ? LightThemeColors.accentColor : DarkThemeColors.accentColor).copyWith(background: isLight ? LightThemeColors.backgroundColor : DarkThemeColors.backgroundColor),
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  changeTheme() {
    // *) check if the current theme is light (default is light)
    bool isLightTheme = MySharedPref.getThemeIsLight();
    // *) store the new theme mode on get storage
    MySharedPref.setThemeIsLight(!isLightTheme);
    // *) let GetX change theme
    Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  /// check if the theme is light or dark
  bool get getThemeIsLight => MySharedPref.getThemeIsLight();