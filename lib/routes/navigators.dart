/*
import 'package:flutter/material.dart';
import '../presentation/screens/create_user/create_user.dart';
import '../presentation/screens/find_profile/find_profile.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/setting/setting_screen.dart';

class HomeNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HomeNavigator({required this.navigatorKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      },
    );
  }
}

class FindNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const FindNavigator({required this.navigatorKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const FindProfile()),
    );
  }
}

class CreateNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const CreateNavigator({required this.navigatorKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const CreateUser()),
    );
  }
}

class SettingNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const SettingNavigator({required this.navigatorKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SettingScreen()),
    );
  }
}
*/
