import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/auth_screen/login_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/Interactive_tutorial_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/preferred_note_method.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/welcome_page.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/what_your_speciality.dart';
import 'package:tbsosick/presentation/screens/auth_screen/sign_up_screen.dart';
import 'package:tbsosick/presentation/screens/buttomNabBar_screen/bottom_nab_bar_screen.dart';
import 'package:tbsosick/presentation/screens/onboarding_screen/onboarding_screen.dart';

class AppRoutes {
  static const String SPLASH = '/splash';
  static const String ONBOARDING = '/onboarding';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String FORGOT_PASSWORD = '/forgot-password';
  static const String HOME = '/home';
  static const String PROFILE = '/profile';
  static const String BOTTOM_NAV_BAR = '/bottom-nav-bar';
  static const String SEARCH = '/search';
  static const String SETTINGS = '/settings';
  static const String WELCOME_PAGE = '/welcome-page';
  static const String WHAT_YOUR_SPECIALITY = '/what-your-speciality';
  static const String PREFERRED_NOTE_METHOD = '/preferred-note-method';
  static const String INTERACTIVE_TUTORIAL = '/interactive-tutorial';
}

final Transition transition = Transition.rightToLeft;

final pages = [
  GetPage(name: AppRoutes.ONBOARDING, page: () => const OnboardingScreen()),
  GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen()),
  GetPage(name: AppRoutes.REGISTER, page: () => SignUpScreen()),
  GetPage(name: AppRoutes.WELCOME_PAGE, page: () => WelcomePage()),
  GetPage(
    name: AppRoutes.WHAT_YOUR_SPECIALITY,
    page: () => WhatYourSpeciality(),
  ),
  GetPage(
    name: AppRoutes.PREFERRED_NOTE_METHOD,
    page: () => PreferredNoteMethod(),
  ),
  GetPage(
    name: AppRoutes.INTERACTIVE_TUTORIAL,
    page: () => InteractiveTutorialScreen(),
  ),
  GetPage(name: AppRoutes.BOTTOM_NAV_BAR, page: () => BottomNabBarScreen()),
];
