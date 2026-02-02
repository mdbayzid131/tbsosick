import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tbsosick/config/routes/app_pages.dart';

import 'package:tbsosick/core/bindings/initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(383, 876),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // appBarTheme: AppBarTheme(
            //   backgroundColor: Color(0xffF9FAFB),
            //   scrolledUnderElevation: 0,
            // ),
            scaffoldBackgroundColor: Color(0xffF9FAFB),
          ),
          initialRoute: RoutePages.onboardingScreen,
          getPages: pages,
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
