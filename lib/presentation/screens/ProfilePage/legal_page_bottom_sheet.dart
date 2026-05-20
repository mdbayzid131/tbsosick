import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/profile_controller.dart';
import 'package:tbsosick/data/models/legal_page_model.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showLegalPageBottomSheet(BuildContext context, {required String slug, required String title}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _LegalPageBottomSheetContent(slug: slug, title: title);
    },
  );
}

class _LegalPageBottomSheetContent extends StatefulWidget {
  final String slug;
  final String title;

  const _LegalPageBottomSheetContent({required this.slug, required this.title});

  @override
  State<_LegalPageBottomSheetContent> createState() => _LegalPageBottomSheetContentState();
}

class _LegalPageBottomSheetContentState extends State<_LegalPageBottomSheetContent> {
  final ProfileController profileController = Get.find<ProfileController>();
  LegalPageDetails? pageDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final details = await profileController.fetchLegalPageDetails(widget.slug);
    if (mounted) {
      setState(() {
        pageDetails = details;
        isLoading = false;
        if (details == null) {
          errorMessage = 'Failed to load content';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.fromLTRB(20.w, 15.w, 20.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.arimo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Scrollable content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            style: GoogleFonts.arimo(color: Colors.red),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Html(
                            data: pageDetails!.content,
                            style: {
                              "body": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontFamily: 'Arimo',
                                fontSize: FontSize(14.sp),
                                color: const Color(0xFF8E8E93),
                                lineHeight: LineHeight(1.6),
                              ),
                              "h1": Style(
                                fontSize: FontSize(20.sp),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                margin: Margins.only(bottom: 12.h, top: 16.h),
                              ),
                              "h2": Style(
                                fontSize: FontSize(18.sp),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                margin: Margins.only(bottom: 10.h, top: 14.h),
                              ),
                              "h3": Style(
                                fontSize: FontSize(16.sp),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                margin: Margins.only(bottom: 8.h, top: 12.h),
                              ),
                              "p": Style(
                                margin: Margins.only(bottom: 12.h),
                              ),
                            },
                          ),
                        ),
            ),

            // Close button at bottom
            SizedBox(height: 16.h),
            SizedBox(
              height: 50.h,
              child: CustomElevatedButton(
                onPressed: () => Get.back(),
                label: tr.close,
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
