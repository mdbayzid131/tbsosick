import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'controller/profile_controller.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showEditProfileBottomSheet(BuildContext context) {
  final profileController = Get.put(ProfileController());
  final user = profileController.user.value;

  final firstNameController = TextEditingController(
    text: user.name != null ? user.name!.split(' ').first : '',
  );
  final lastNameController = TextEditingController(
    text: user.name != null && user.name!.split(' ').length > 1
        ? user.name!.split(' ').sublist(1).join(' ')
        : '',
  );
  final specialtyController = TextEditingController(text: user.specialty ?? '');
  final hospitalController = TextEditingController(text: user.hospital ?? '');
  final emailController = TextEditingController(text: user.email ?? '');
  final phoneController = TextEditingController(text: user.phone ?? '');

  Rx<File?> pickedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.arimo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 32.h,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Image Picker
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          return Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F7),
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.w),
                              child: pickedImage.value != null
                                  ? Image.file(
                                      pickedImage.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : user.profilePicture != null
                                  ? Image.network(
                                      user.profilePicture!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.person,
                                            size: 50.w,
                                            color: Colors.grey,
                                          ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 50.w,
                                      color: Colors.grey,
                                    ),
                            ),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: pickImage,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9945FF),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: firstNameController,
                          hintText: 'John',
                          label: 'First Name',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          controller: lastNameController,
                          hintText: 'Doe',
                          label: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  CustomTextField(
                    controller: specialtyController,
                    hintText: 'General Surgery',
                    label: 'Specialty',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: hospitalController,
                    hintText: 'City Hospital',
                    label: 'Hospital ',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'john.doe@example.com',
                    label: 'Email',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: phoneController,
                    hintText: '(555) 987-6543',
                    label: 'Phone',
                  ),
                  SizedBox(height: 25.h),

                  SizedBox(
                    height: 50.h,
                    child: Obx(() {
                      return profileController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              label: 'Save Changes',
                              onPressed: () async {
                                final name =
                                    '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
                                        .trim();

                                if (pickedImage.value != null) {
                                  await profileController.updateProfileImage(
                                    pickedImage.value!,
                                  );
                                }

                                await profileController.updateProfile(
                                  name: name,
                                  phone: phoneController.text.trim(),
                                  specialty: specialtyController.text.trim(),
                                  hospital: hospitalController.text.trim(),
                                  email: emailController.text.trim(),
                                );
                                Navigator.pop(context);
                              },
                            );
                    }),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
