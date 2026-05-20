import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showPaymentMethodBottomSheet(BuildContext context) {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final tr = AppLocalizations.of(context)!;
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
                        tr.paymentMethod,
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
                  CustomTextField(
                    controller: linkController,
                    hintText: tr.cardNumberPlaceholder,
                    label: tr.cardNumber,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: tr.expiryDatePlaceholder,
                          label: tr.expiryDate,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(hintText: tr.cvv, label: tr.cvv),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  CustomTextField(
                    controller: locationController,
                    hintText: tr.johnDoePlaceholder,
                    label: tr.cardholderName,
                  ),
                  SizedBox(height: 12.h),

                  SizedBox(
                    height: 50.h,

                    child: CustomElevatedButton(
                      label: tr.saveChanges,
                      onPressed: () {},
                    ),
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
