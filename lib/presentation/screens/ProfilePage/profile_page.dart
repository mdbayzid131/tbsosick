import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/profile_controller.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/terms_of_service.dart';
import '../../../config/constants/image_paths.dart';
import '../home/notification_bottom.dart';
import 'Privacy & Security bottom.dart';
import 'UpdatePaymentMethodBottom.dart';
import 'edit_profile_bottom.dart';
import 'log_out_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF271E3E),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: const Color(0xFF9945FF),
          onRefresh: profileController.getProfileData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120.h,
                collapsedHeight: 60.h,
                pinned: true,
                floating: false,
                elevation: 0,
                backgroundColor: const Color(0xFF6C36B2),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF271E3E),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsetsDirectional.only(
                    start: 20.w,
                    bottom: 16.h,
                  ),
                  title: Text(
                    'Profile',
                    style: GoogleFonts.arimo(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      color: Color(0xFF6C36B2),
                    ),
                  ),
                  collapseMode: CollapseMode.pin,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 20.h),
                      _buildProfileCard(),
                      SizedBox(height: 16.h),
                      _buildPremiumPlanCard(),
                      SizedBox(height: 24.h),
                      Text(
                        'ACCOUNT',
                        style: GoogleFonts.arimo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.camera_alt_outlined,
                              iconColor: const Color(0xFF8B5CF6),
                              title: 'Edit Profile',
                              onTap: () {
                                showEditProfileBottomSheet(context);
                              },
                            ),
                            Divider(
                              height: 1.h,
                              color: const Color(0xFFF3F4F6),
                            ),
                            _buildMenuItem(
                              icon: Icons.notifications_outlined,
                              iconColor: const Color(0xFF8B5CF6),
                              title: 'Notifications',
                              badge: 3,
                              onTap: () {
                                showNotificationBottomSheet(context);
                              },
                            ),
                            Divider(
                              height: 1.h,
                              color: const Color(0xFFF3F4F6),
                            ),
                            _buildMenuItem(
                              icon: Icons.credit_card_outlined,
                              iconColor: const Color(0xFF8B5CF6),
                              title: 'Subscription',
                              onTap: () {
                                showUpdatePackageBottomSheet(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'PREFERENCES',
                        style: GoogleFonts.arimo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.lock_outline,
                              iconColor: const Color(0xFF6B7280),
                              title: 'Privacy & Security',
                              onTap: () {
                                showPrivacyAndSecurityBottomSheet(context);
                              },
                            ),
                            Divider(
                              height: 1.h,
                              color: const Color(0xFFF3F4F6),
                            ),
                            _buildMenuItem(
                              icon: Icons.description_outlined,
                              iconColor: const Color(0xFF6B7280),
                              title: 'Terms of Service',
                              onTap: () {
                                showTermsOfServiceBottomSheet(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: () {
                          showSignOutConfirmationBottomSheet(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: const Color(0xFFEF4444),
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Sign Out',
                                style: GoogleFonts.arimo(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: Text(
                          'SMRTSCRUB Version 1.0.0',
                          style: GoogleFonts.arimo(
                            fontSize: 12.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header with gradient background
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 50.h,
        bottom: 24.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF9945FF), Color(0xFF271E3E)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Text(
        'Profile',
        style: GoogleFonts.arimo(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // Profile card with avatar and stats
  Widget _buildProfileCard() {
    return Obx(() {
      final user = profileController.user.value;
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar with camera icon
                Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8E3DF6),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.w),
                        child: user.profilePicture != null
                            ? Image.network(
                                user.profilePicture!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Text(
                                        user.name
                                                ?.substring(0, 2)
                                                .toUpperCase() ??
                                            'DA',
                                        style: GoogleFonts.arimo(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              )
                            : Center(
                                child: Text(
                                  user.name?.substring(0, 2).toUpperCase() ??
                                      'DA',
                                  style: GoogleFonts.arimo(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showEditProfileBottomSheet(context);
                        },
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9945FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.w),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Guest User',
                        style: GoogleFonts.arimo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff000000),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        user.specialty ?? 'Specialty not set',
                        style: GoogleFonts.arimo(
                          fontSize: 15.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        user.hospital ?? 'Hospital not set',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // // Divider
            // Divider(height: 1.h, color: const Color(0xFFE5E7EB)),

            // // Stats row
            // Row(
            //   children: [
            //     Expanded(child: _buildStatItem('47', 'Cards')),
            //     Container(
            //       width: 1.w,
            //       height: 40.h,
            //       color: const Color(0xFFE5E7EB),
            //     ),
            //     Expanded(child: _buildStatItem('23', 'Shared')),
            //     Container(
            //       width: 1.w,
            //       height: 40.h,
            //       color: const Color(0xFFE5E7EB),
            //     ),
            //     Expanded(child: _buildStatItem('156', 'Completed')),
            //   ],
            // ),
          ],
        ),
      );
    });
  }

 
  // Premium Plan card
  Widget _buildPremiumPlanCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF9945FF), Color(0xFF271E3E)],
        ),

        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with crown icon and checkmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Premium Plan',
                    style: GoogleFonts.arimo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: SvgPicture.asset(
                  ImagePaths.chosePlanIcon,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Active until text
          Text(
            'Active until Jan 2027',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16.h),
          // Features list
          _buildFeatureItem('Unlimited cards'),
          SizedBox(height: 8.h),
          _buildFeatureItem('Advanced analytics'),
          SizedBox(height: 8.h),
          _buildFeatureItem('Priority support'),
          SizedBox(height: 20.h),
          // Manage Subscription button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Manage subscription
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
              ),
              child: Text(
                'Manage Subscription',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6750A4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Feature item widget
  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.arimo(fontSize: 15.sp, color: Colors.white),
        ),
      ],
    );
  }

  // Menu item widget
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    int? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0FF),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge.toString(),
                  style: GoogleFonts.arimo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF9CA3AF),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
