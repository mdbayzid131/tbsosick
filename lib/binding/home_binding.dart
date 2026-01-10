/*


class HomeBinding extends Bindings {
  @override
  void dependencies() {
     // Get.lazyPut<AuthController>(() => AuthController());
    Get.put(ApiClient());
    Get.put(UserProfileManageRepo(apiClient: Get.find<ApiClient>()));
    Get.put(AuthRepo(apiClient: Get.find<ApiClient>()));

    Get.put(AuthController(Get.find<AuthRepo>()));

     Get.put(HomePageController(Get.find<UserProfileManageRepo>()), permanent: true);

    Get.put(NetworkController(), permanent: true);

  }
}
*/
