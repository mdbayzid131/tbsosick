import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/bindings/initial_binding.dart';
import 'package:tbsosick/core/controllers/language_controller.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(383, 876),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('es'), Locale('de')],
            locale: languageController.locale.value,
            fallbackLocale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // appBarTheme: AppBarTheme(
              //   backgroundColor: Color(0xffF9FAFB),
              //   scrolledUnderElevation: 0,
              // ),
              scaffoldBackgroundColor: Color(0xffF9FAFB),
            ),
            initialRoute: AppRoutes.splash,
            getPages: pages,
            initialBinding: InitialBinding(),
          ),
        );
      },
    );
  }
}
