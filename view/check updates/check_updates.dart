import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckUpdates extends StatelessWidget {
  CheckUpdates({super.key});

  final Uri _googlePlayUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.medicineway.aua_questions");

  Future<void> _launchUrl() async {
    if (!await launchUrl(
      _googlePlayUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $_googlePlayUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Update Required",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16.sp),
              Text(
                "Please update the app to continue using all features.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 32.sp),
              LottieBuilder.asset(
                "assets/animations/update_animation.json",
                height: 200.sp,
                width: 200.sp,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 32.sp),
              ElevatedButton.icon(
                onPressed: _launchUrl,
                icon: const Icon(
                  Icons.play_arrow_sharp,
                  color: Colors.green,
                ),
                label: const Text(
                  "Update from Google Play",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
