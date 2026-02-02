
import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/auth_screen/login_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/Interactive_tutorial_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/preferred_note_method.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/welcome_page.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/what_your_speciality.dart';
import 'package:tbsosick/presentation/screens/auth_screen/sign_up_screen.dart';
import 'package:tbsosick/presentation/screens/buttomNabBar_screen/bottom_nab_bar_screen.dart';
import 'package:tbsosick/presentation/screens/home/New%20Private%20Card/new_private_card.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/new_preference_card.dart';
import 'package:tbsosick/presentation/screens/onboarding_screen/onboarding_screen.dart';
class AppRoutes {
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String FORGOT_PASSWORD = '/forgot-password';
  static const String HOME = '/home';
  static const String PROFILE = '/profile';
  static const String BOTTOM_NAV_BAR = '/bottom-nav-bar';
  static const String SEARCH = '/search';
  static const String SETTINGS = '/settings';
}


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
  static const String newPreferenceCard = '/NewPreferenceCard';
  static const String newPrivateCard = '/NewPrivateCard';
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
  GetPage(name: RoutePages.newPreferenceCard, page: () =>  NewPreferenceCard()),
  GetPage(name: RoutePages.newPrivateCard, page: () =>  NewPrivateCard()),
];