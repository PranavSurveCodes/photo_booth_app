import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_booth/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        bottomAppBarTheme: BottomAppBarThemeData(
          color: Colors.purple,
          height: 66,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
        ),
      ),
      getPages: AppRoutes().routes,
    );
  }
}
