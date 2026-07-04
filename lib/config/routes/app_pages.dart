import 'package:get/get.dart';
import 'package:tbsosick/presentation/binding/bottom_nab_bar_binding.dart';
import 'package:tbsosick/presentation/screens/auth_screen/login_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/interactive_tutorial/interactive_tutorial_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/interactive_tutorial/interactive_tutorial_binding.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/preferred_note_method.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/select_package.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/welcome_page.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/what_your_speciality.dart';
import 'package:tbsosick/presentation/screens/auth_screen/otp_verification_screen.dart';
import 'package:tbsosick/presentation/screens/auth_screen/sign_up_screen.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/binding/subscription_binding.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/view/subscription_screen.dart';

import 'package:tbsosick/presentation/screens/buttomNabBar_screen/bottom_nab_bar_screen.dart';
import 'package:tbsosick/presentation/screens/home/binding/card_datails_binding.dart';
import 'package:tbsosick/presentation/screens/home/preference_card_details.dart';
import 'package:tbsosick/presentation/screens/calendar_page/procedure_details.dart';
import 'package:tbsosick/presentation/screens/my%20cards/binding/my_cards_binding.dart';
import 'package:tbsosick/presentation/screens/my%20cards/view/my_cards_screeen.dart';
import 'package:tbsosick/presentation/screens/onboarding_screen/onboarding_screen.dart';
import 'package:tbsosick/presentation/screens/splash_screen/binding/splash_binding.dart';
import 'package:tbsosick/presentation/screens/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String bottomNavBar = '/bottom-nav-bar';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String welcomePage = '/welcome-page';
  static const String selectPackage = '/select-package';
  static const String whatYourSpeciality = '/what-your-speciality';
  static const String preferredNoteMethod = '/preferred-note-method';
  static const String interactiveTutorial = '/interactive-tutorial';
  static const String verifyEmail = '/verify-email';
  static const String otpVerification = '/otp-verification';
  static const String cardDetails = '/card-details';
  static const String myCards = '/my-cards';
  static const String subscription = '/subscription';
  static const String eventDetails = '/event-details';
}

final Transition transition = Transition.rightToLeft;

final pages = [
  GetPage(
    name: AppRoutes.splash,
    page: () => const SplashScreen(),
    bindings: [SplashBinding()],
  ),
  GetPage(
    name: AppRoutes.onboarding,
    page: () => const OnboardingScreen(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.register,
    page: () => SignUpScreen(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.welcomePage,
    page: () => WelcomePage(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.selectPackage,
    page: () => const SelectPackageScreen(),
    bindings: [SubscriptionBinding()],
  ),
  GetPage(
    name: AppRoutes.whatYourSpeciality,
    page: () => WhatYourSpeciality(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.preferredNoteMethod,
    page: () => PreferredNoteMethod(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.interactiveTutorial,
    page: () => InteractiveTutorialScreen(),
    bindings: [InteractiveTutorialBinding()],
  ),
  GetPage(
    name: AppRoutes.bottomNavBar,
    page: () => BottomNabBarScreen(),
    bindings: [BottomNabBarBinding()],
  ),
  GetPage(
    name: AppRoutes.otpVerification,
    page: () => OtpVerificationScreen(),
    bindings: [],
  ),
  GetPage(
    name: AppRoutes.cardDetails,
    page: () => PreferenceCardDetails(),
    bindings: [CardDetailsBinding()],
  ),
  GetPage(
    name: AppRoutes.myCards,
    page: () => MyCardsScreen(),
    bindings: [MyCardsBinding()],
  ),
  GetPage(
    name: AppRoutes.subscription,
    page: () => const SubscriptionScreen(),
    bindings: [SubscriptionBinding()],
  ),
  GetPage(
    name: AppRoutes.eventDetails,
    page: () => ProcedureDetailsScreen(id: (Get.arguments as String?) ?? ''),
  ),
];
