// /*
// import 'dart:typed_data';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' hide ByteData;
// import 'package:get/get.dart' hide Response, FormData, MultipartFile;
// import 'package:image_picker/image_picker.dart';
//
// import '../../core/constants/image_paths.dart';
// import '../../core/utils/custom_snackbar.dart';
// import '../../data/models/NotificationItemModel.dart';
// import '../../data/models/children_data_model.dart';
// import '../../data/models/profile_response_model.dart';
// import '../../data/models/user_profile_model.dart';
// import '../../data/repo/user_profile_manage_repo.dart';
// import '../../data/services/api_checker.dart';
//
// class HomePageController extends GetxController {
//   final UserProfileManageRepo userProfileManageRepo;
//
//   HomePageController(this.userProfileManageRepo);
//
//   Future<void> loadData() async {
//     await getProfile();
//     await getChildrenProfile();
//   }
//
//   RxBool isLoading = RxBool(false);
//
//   /// Profile data store
//   Rx<UserProfileModel?> profile = Rx<UserProfileModel?>(null);
//
//   Future<void> getProfile() async {
//     try {
//       isLoading(true);
//
//       Response<dynamic> response = await userProfileManageRepo.getProfile();
//       ApiChecker.checkApi(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final profileResponseModel = ProfileResponseModel.fromJson(
//           response.data,
//         );
//
//         profile.value = profileResponseModel.data;
//
//         print(profile.value?.name);
//         print(profile.value?.email);
//         print(profile.value?.profilePicture);
//       } else {
//         showCustomSnackBar("Server is not responding", isError: true);
//       }
//     } catch (e) {
//       if (e is DioException) {
//         ApiChecker.handleError(e);
//       } else {
//         showCustomSnackBar("Failed to connect to server ", isError: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   /// children data store
//   RxList<ChildData> childData = <ChildData>[].obs;
//
//   Future<void> getChildrenProfile() async {
//     try {
//       isLoading(true);
//
//       Response<dynamic> response = await userProfileManageRepo
//           .getChildrenProfile();
//       ApiChecker.checkApi(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final childrenResponse = ChildrenResponse.fromJson(response.data);
//
//         childData.assignAll(childrenResponse.data);
//       } else {
//         showCustomSnackBar("Server is not responding", isError: true);
//       }
//     } catch (e) {
//       if (e is DioException) {
//         ApiChecker.handleError(e);
//       } else {
//         showCustomSnackBar("Failed to connect to server ", isError: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   ///=====================================================================
//   /// ===================== profile update =====================
//   ///=====================================================================
//   Future<void> updateProfile({
//     required String name,
//     required BuildContext context,
//   }) async {
//     try {
//       isLoading(true);
//
//       Response<dynamic> response = await userProfileManageRepo.updateProfile({
//         "name": name,
//       });
//       ApiChecker.checkApi(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         await getProfile();
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       if (e is DioException) {
//         ApiChecker.handleError(e);
//       } else {
//         showCustomSnackBar("Error: $e", isError: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   /// ===================== profile photo update =====================
//
//   Future<void> pickImageFromGallery(BuildContext context) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       FormData formData = FormData.fromMap({
//         "profilePicture": await MultipartFile.fromFile(image.path),
//       });
//
//       Response response = await userProfileManageRepo.updateProfileImage(
//         formData,
//       );
//
//       ApiChecker.checkApi(response);
//       if (response.statusCode == 200) {
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         await getProfile();
//
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     }
//   }
//
//   Future<void> uploadAvatar(String assetPath) async {
//     // assets থেকে file লোড করতে হবে
//     ByteData byteData = await rootBundle.load(assetPath);
//     List<int> imageData = byteData.buffer.asUint8List();
//
//     FormData formData = FormData.fromMap({
//       "profilePicture": MultipartFile.fromBytes(
//         imageData,
//         filename: assetPath.split("/").last, // ফাইল নাম
//       ),
//     });
//
//     Response response = await userProfileManageRepo.updateProfileImage(
//       formData,
//     );
//
//     if (response.statusCode == 200) {
//       showCustomSnackBar("Avatar updated successfully", isError: false);
//       await getProfile();
//     }
//   }
//
//   ///=====================================================================
//   /// ===================== children profile update =====================
//   ///=====================================================================
//
//   Future<void> updateChildrenProfile({
//     required String childId,
//     required BuildContext context,
//     required String name,
//     required String dob,
//   }) async {
//     try {
//       isLoading(true);
//
//       Response<dynamic> response = await userProfileManageRepo
//           .updateChildProfile(childId, {"name": name, "dateOfBirth": dob});
//       ApiChecker.checkApi(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         await getChildrenProfile();
//
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       if (e is DioException) {
//         ApiChecker.handleError(e);
//       } else {
//         showCustomSnackBar("Error: $e", isError: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> childrenPickImageFromGallery({
//     required String childId,
//     required BuildContext context,
//   }) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       FormData formData = FormData.fromMap({
//         "profileImage": await MultipartFile.fromFile(image.path),
//       });
//
//       Response response = await userProfileManageRepo.updateChildProfileImage(
//         childId,
//         formData,
//       );
//
//       ApiChecker.checkApi(response);
//       if (response.statusCode == 200) {
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         await getChildrenProfile();
//
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     }
//   }
//
//   Future<void> childrenUploadAvatar({
//     required String childId,
//     required String assetPath,
//   }) async {
//     ByteData byteData = await rootBundle.load(assetPath);
//     List<int> imageData = byteData.buffer.asUint8List();
//
//     FormData formData = FormData.fromMap({
//       "profileImage": MultipartFile.fromBytes(
//         imageData,
//         filename: assetPath.split("/").last,
//       ),
//     });
//
//     Response response = await userProfileManageRepo.updateChildProfileImage(
//       childId,
//       formData,
//     );
//
//     if (response.statusCode == 200) {
//       showCustomSnackBar("Avatar updated successfully", isError: false);
//       await getChildrenProfile();
//     }
//   }
//
//   ///=====================================================================
//   /// ===================== children profile create =====================
//   ///=====================================================================
//
//   // Future<void> createChildrenProfile({
//   //   required BuildContext context,
//   //   required String name,
//   //   required String dob,
//   // }) async {
//   //   try {
//   //     isLoading(true);
//   //
//   //     Response<dynamic> response = await userProfileManageRepo
//   //         .createChildProfile({"name": name, "dateOfBirth": dob});
//   //     ApiChecker.checkApi(response);
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       showCustomSnackBar("Profile updated successfully", isError: false);
//   //       await uploadProfileImage();
//   //       await getChildrenProfile();
//   //
//   //       if (context.mounted) {
//   //         Navigator.pop(context);
//   //       }
//   //     }
//   //   } catch (e) {
//   //     if (e is DioException) {
//   //       ApiChecker.handleError(e);
//   //     } else {
//   //       showCustomSnackBar("Error: $e", isError: true);
//   //     }
//   //   } finally {
//   //     isLoading(false);
//   //   }
//   // }
//
//   List<NotificationItem> notifications = [
//     NotificationItem(
//       id: '1',
//       message:
//           'Hey Your Grandson Zoe Send You A Voice Note, Please Click To Hear The Voice Note!',
//       category: 'voice_note',
//       timestamp: '2h Ago',
//       imagePath: ImagePaths.avatarProfile2,
//       name: 'Sabbir',
//       voicePath:
//           '/data/user/0/com.example.gifting_app/app_flutter/voice_1765588225384.m4a',
//     ),
//     NotificationItem(
//       id: '2',
//       message: 'Grandma Debbie Contribute 10\$. Tap here to See..',
//       category: 'contribute_alert',
//       timestamp: '2h Ago',
//       imagePath: ImagePaths.avatarProfile3,
//       name: 'Sojib',
//     ),
//     NotificationItem(
//       id: '3',
//       message: 'Khaled ahmed nayeem wants to follow you!',
//       category: 'follow_request',
//       timestamp: '2h Ago',
//       imagePath: ImagePaths.avatarProfile4,
//       name: 'khaled',
//     ),
//   ];
// */
// /*//*
// /===========================================================
//   Future<XFile?> createChildePickImageFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     return image;
//   }
//
//   Future<void> createChildrenProfileImage() async {
//     XFile? selectedImage = await createChildePickImageFromGallery();
//
//     if (selectedImage != null) {
//       FormData formData = FormData.fromMap({
//         "profileImage": await MultipartFile.fromFile(selectedImage.path),
//       });
//
//       Response response = await userProfileManageRepo.createChildProfileImage(
//         formData,
//       );
//
//       ApiChecker.checkApi(response);
//       if (response.statusCode == 200) {
//         showCustomSnackBar("Profile updated successfully", isError: false);
//         await getChildrenProfile();
//       }
//     }
//   }
// //===================================================================
//
//   Future<List<int>> createChildrenPickImageFromAvatar({
//     required String assetPath,
//   }) async {
//     ByteData byteData = await rootBundle.load(assetPath);
//     List<int> imageData = byteData.buffer.asUint8List();
//     return imageData;
//   }
//
//   Future<void> createChildrenUploadAvatar({required String assetPath}) async {
//     List<int> imageData = await createChildrenPickImageFromAvatar(
//       assetPath: assetPath,
//     );
//
//     FormData formData = FormData.fromMap({
//       "profileImage": MultipartFile.fromBytes(
//         imageData,
//         filename: assetPath.split("/").last,
//       ),
//     });
//
//     Response response = await userProfileManageRepo.createChildProfileImage(
//       formData,
//     );
//
//     if (response.statusCode == 200) {
//       showCustomSnackBar("Avatar updated successfully", isError: false);
//       await getChildrenProfile();
//     }
//   }*//*
//
//
//
//
//   ///
// ///
// ///
//
//
//
//
//   /// Selected image source
//   Rx<ImageSourceType?> selectedImageSource = Rx<ImageSourceType?>(null);
//
//   /// Gallery picked image
//   Rx<XFile?> selectedGalleryImage = Rx<XFile?>(null);
//
//   /// Avatar picked image (asset path)
//   Rx<String?> selectedAvatarPath = Rx<String?>(null);
//
//
//
//   Future<void> childCreatePickImageFromGallery() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       selectedGalleryImage.value = image;
//       selectedAvatarPath.value = null; // clear avatar
//       selectedImageSource.value = ImageSourceType.gallery;
//     }
//   }
//
//
//   void selectAvatar({required String assetPath}) {
//     selectedAvatarPath.value = assetPath;
//     selectedGalleryImage.value = null; // clear gallery
//     selectedImageSource.value = ImageSourceType.avatar;
//   }
//
//   Future<void> childrenCreateChildrenProfile({
//     required BuildContext context,
//     required String name,
//     required String dob,
//   }) async {
//     try {
//       isLoading(true);
//
//       final Map<String, dynamic> data = {
//         "name": name,
//         "dateOfBirth": dob,
//       };
//
//       /// ---------- IMAGE HANDLE ----------
//       if (selectedImageSource.value == ImageSourceType.gallery &&
//           selectedGalleryImage.value != null) {
//
//         data["profileImage"] = await MultipartFile.fromFile(
//           selectedGalleryImage.value!.path,
//         );
//
//       } else if (selectedImageSource.value == ImageSourceType.avatar &&
//           selectedAvatarPath.value != null) {
//
//         final bytes = await rootBundle.load(selectedAvatarPath.value!);
//         data["profileImage"] = MultipartFile.fromBytes(
//           bytes.buffer.asUint8List(),
//           filename: selectedAvatarPath.value!.split("/").last,
//         );
//       }
//
//       final formData = FormData.fromMap(data);
//
//       final response =
//       await userProfileManageRepo.createChildProfile(formData);
//
//       ApiChecker.checkApi(response);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         showCustomSnackBar("Child profile created successfully", isError: false);
//
//         await getChildrenProfile();
//
//         if (context.mounted) {
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       if (e is DioException) {
//         ApiChecker.handleError(e);
//       } else {
//         showCustomSnackBar("Something went wrong", isError: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//
//
//
//
// }
// enum ImageSourceType { gallery, avatar }
// */
