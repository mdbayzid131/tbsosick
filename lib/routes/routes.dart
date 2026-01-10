import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:tbsosick/presentation/screens/onboarding_screen/onboarding_screen.dart';

import '../presentation/screens/auth_screen/login_screen.dart';

class RoutePages {
  static const String splashScreen = '/splashScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String bottomNabBarScreen = '/bottomNabBarScreen';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
}

final Transition transition = Transition.rightToLeft;

final pages = [
  GetPage(
    name: RoutePages.onboardingScreen,
    page: () => const OnboardingScreen(),
  ),  GetPage(
    name: RoutePages.loginScreen,
    page: () => const LoginScreen(),
  ),
];
