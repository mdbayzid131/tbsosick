import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),  // Padding for the container
      decoration: BoxDecoration(
        color: Colors.white,  // Background color of the container
        borderRadius: BorderRadius.circular(16.r),  // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),  // Shadow color
            blurRadius: 12,  // Blur radius for shadow
            offset: Offset(0, 4),  // Shadow offset
          ),
        ],
      ),
      child: child,
    );
  }
}
