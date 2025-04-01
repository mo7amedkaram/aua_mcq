import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckUpdates extends StatelessWidget {
  CheckUpdates({super.key});
  final urlGooglePlay = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.medicineway.aua_questions");

  Future<void> _launchUrl({required Uri url}) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تحديث التطبيق",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "Tajawal",
              ),
            ),
            Text(
              "برجاء تحديث التطبيق حتى تتمكن من مواصلة استخدامه",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: "Tajawal",
                color: Colors.grey,
              ),
            ),
            Container(
              height: 250.sp,
              width: 250.sp,
              child: LottieBuilder.asset(
                  "assets/images/Animation - 1705106352526.json"),
            ),
            SizedBox(
              height: 15.sp,
            ),
            ElevatedButton.icon(
              onPressed: () {
                _launchUrl(url: urlGooglePlay);
              },
              icon: const Icon(
                Icons.play_arrow_sharp,
                color: Colors.green,
              ),
              label: const Text("اضغط لتحديث التطبيق من المتجر"),
            ),
          ],
        ),
      )),
    );
  }
}
