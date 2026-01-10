/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../routes/navigators.dart';
import '../../controllers/bottom_nab_bar_controller.dart';
import '../../widgets/custom_buttom_nab_bar.dart';

class BottomNabBarScreen extends StatefulWidget {
  const BottomNabBarScreen({super.key});

  @override
  State<BottomNabBarScreen> createState() => _BottomNabBarScreenState();
}

class _BottomNabBarScreenState extends State<BottomNabBarScreen> {
  final BottomNabBarController controller = Get.find<BottomNabBarController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevents default back navigation
      onPopInvokedWithResult: (didPop, result) async {
        // Your custom back handling logic
        final shouldPop = await controller.onWillPop();

        if (shouldPop) {
          Navigator.of(context).maybePop(result);
          // `result` is the optional value returned when popping
        }
      },
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: IndexedStack(
              key: ValueKey<int>(controller.currentIndex.value),
              index: controller.currentIndex.value,
              children: [
                HomeNavigator(navigatorKey: controller.navigatorKeys[0]),
                FindNavigator(navigatorKey: controller.navigatorKeys[1]),
                CreateNavigator(navigatorKey: controller.navigatorKeys[2]),
                SettingNavigator(navigatorKey: controller.navigatorKeys[3]),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Obx(
          () => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
          ),
        ),
      ),
    );
  }
}
*/
