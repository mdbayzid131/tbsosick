import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom2.dart';
import 'package:tbsosick/presentation/widgets/custom_date_picker.dart';

import '../../controllers/form_validation.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_time_picker.dart';

void showEditProfileBottomSheet(BuildContext context) {
  final emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final validator = Get.find<FormValidationController>();

  final formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Form(
              key: formKey,
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
          
                  SizedBox(height: 12.h),
          
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
          
                          hintText: 'John',
                          label: 'First Name',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
          
                          hintText: 'Deo',
                          label: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
          
                  CustomTextField(
                    controller: linkController,
                    hintText: 'General Surgery',
                    label: 'Specialty',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: locationController,
                    hintText: 'City Hospital',
                    label: 'Hospital ',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: notesController,
                    hintText: 'john.doe@example.com',
                    label: 'Email',
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: notesController,
                    hintText: '(555) 987-6543',
                    label: 'Phone',
                  ),
                  SizedBox(height: 25.h),
          
                  SizedBox(
                    height: 50.h,
          
                      child: CustomElevatedButton(label: 'Save Changes', onPressed: () {})),
          
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
