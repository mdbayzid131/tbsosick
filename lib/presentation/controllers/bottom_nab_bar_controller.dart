import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNabBarController extends GetxController {



  // void changePage(int index) {
  //   if (currentIndex.value == index) {
  //     navigatorKeys[index]
  //         .currentState
  //         ?.popUntil((route) => route.isFirst);
  //   } else {
  //     currentIndex.value = index;
  //   }
  // }
  //





  RxInt currentIndex = 0.obs;

  final List<GlobalKey<NavigatorState>> navigatorKeys =
  List.generate(4, (_) => GlobalKey<NavigatorState>());

  void changePage(int index) {
    if (currentIndex.value == index) {
      navigatorKeys[index]
          .currentState
          ?.popUntil((route) => route.isFirst);
    } else {
      navigatorKeys[currentIndex.value]
          .currentState
          ?.popUntil((route) => route.isFirst);

      currentIndex.value = index;
    }
  }

  Future<bool> onWillPop() async {
    final NavigatorState currentNavigator =
    navigatorKeys[currentIndex.value].currentState!;

    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

}
