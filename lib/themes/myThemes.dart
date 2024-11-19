import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,ThemeData>((ref)=>ThemeNotifier());

class MyTheme{
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(35, 47, 55, 1.0); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    bottomAppBarTheme: const BottomAppBarTheme(
        color: drawerColor
    ),
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    bottomAppBarTheme: const BottomAppBarTheme(
      color: drawerColor
    ),
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
      elevation: 0,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData>{
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark}):_mode = mode,super(MyTheme.darkModeAppTheme){
    getTheme();
  }

  ThemeMode get mode =>_mode;

  Future<ThemeData> getTheme()async{
    final prefs = await SharedPreferences.getInstance();
    bool? themeTurns =  prefs.getBool('red-theme');
    return themeTurns??true?MyTheme.darkModeAppTheme:MyTheme.lightModeAppTheme;
  }

  void toggleTheme()async{
    final prefs = await SharedPreferences.getInstance();
    if(_mode == ThemeMode.light){
      state = MyTheme.darkModeAppTheme;
      prefs.setBool("red-theme", true);
      _mode = ThemeMode.dark;
    }else{
      state = MyTheme.lightModeAppTheme;
      prefs.setBool("red-theme", false);
      _mode = ThemeMode.light;
    }
  }

}