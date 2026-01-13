import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tbsosick/presentation/screens/onboarding_screen/onboarding_screen.dart';

import '../presentation/screens/auth_screen/login_screen.dart';
import '../presentation/screens/auth_screen/quick_setup/Interactive Tutorial/Interactive_tutorial_screen.dart';
import '../presentation/screens/auth_screen/quick_setup/preferred_note_method.dart';
import '../presentation/screens/auth_screen/quick_setup/welcome_page.dart';
import '../presentation/screens/auth_screen/quick_setup/what_your_speciality.dart';
import '../presentation/screens/auth_screen/sign_up_screen.dart';
import '../presentation/screens/buttomNabBar_screen/bottom_nab_bar_screen.dart';

class RoutePages {
  static const String splashScreen = '/splashScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String bottomNabBarScreen = '/bottomNabBarScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/SignUpScreen';
  static const String registerScreen = '/registerScreen';
  static const String welcomePage = '/WelcomePage';
  static const String whatYourSpeciality = '/WhatYourSpeciality';
  static const String preferredNoteMethod = '/PreferredNoteMethod';
  static const String interactiveTutorialScreen = '/InteractiveTutorialScreen';
}

final Transition transition = Transition.rightToLeft;

final pages = [
  GetPage(
    name: RoutePages.onboardingScreen,
    page: () => const OnboardingScreen(),
  ),
  GetPage(name: RoutePages.loginScreen, page: () => const LoginScreen()),
  GetPage(name: RoutePages.signUpScreen, page: () => const SignUpScreen()),
  GetPage(name: RoutePages.welcomePage, page: () =>  WelcomePage()),
  GetPage(name: RoutePages.whatYourSpeciality, page: () =>  WhatYourSpeciality()),
  GetPage(name: RoutePages.preferredNoteMethod, page: () =>  PreferredNoteMethod()),
  GetPage(name: RoutePages.interactiveTutorialScreen, page: () =>  InteractiveTutorialScreen()),
  GetPage(name: RoutePages.bottomNabBarScreen, page: () =>  BottomNabBarScreen()),
];
