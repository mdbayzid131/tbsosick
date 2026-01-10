/*
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../core/utils/custom_snackbar.dart';
import '../../presentation/controllers/homepgeController.dart';

class NetworkController extends GetxController {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _wasOffline = false; // Track previous state
  bool _snackbarShown = false;

  @override
  void onInit() {
    super.onInit();
    _initialCheck();
    _listenInternetChanges();
  }



  /// ================= LISTEN INTERNET STATE =================
  void _listenInternetChanges() {
    _subscription =
        Connectivity().onConnectivityChanged.listen((results) async {
          // No network interface
          if (results.isEmpty || results.contains(ConnectivityResult.none)) {
            _handleOffline("No Internet Connection");
            return;
          }

          // Check actual internet access
          final hasInternet =
          await InternetConnection().hasInternetAccess;

          if (hasInternet) {
            _handleOnline();
          } else {
            _handleOffline("Internet not reachable");
          }
        });
  }

  /// ================= OFFLINE HANDLER =================
  void _handleOffline(String message) {
    _wasOffline = true;

    if (_snackbarShown) return;

    _snackbarShown = true;
    showCustomSnackBar(
      message,
      isError: true,
      duration: const Duration(days: 1), // stays until internet returns
    );



  }

  /// ================= ONLINE HANDLER =================
  void _handleOnline() {
    if (_wasOffline) {
      _wasOffline = false;
      _snackbarShown = false;

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      _callApis();
    }
  }

  /// ================= API REFRESH =================
  void _callApis() async{
    final homeController = Get.find<HomePageController>();
    await homeController.loadData();

    print("🔄 Internet restored → APIs refreshed");
  }




  Future<void> _initialCheck() async {
    final hasInternet = await InternetConnection().hasInternetAccess;

    if (hasInternet) {
      _callApis(); // 🔥 app open হতেই API call
    } else {
      _handleOffline("No Internet Connection");
    }
  }


  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
*/
