import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Ads Helper/ads_helper.dart';
import '../Questions Page/questions_screen.dart';
import 'subject_controller.dart';

class SubjectPage extends StatefulWidget {
  String moduleId;
  String moduleName;
  SubjectPage({
    super.key,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  late SubjectController controller;
  BannerAd? _bannerAd;

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  Widget _buildBottomNavigationBar() {
    // Assuming _bannerAd is a BannerAd object and properly initialized.
    if (_bannerAd != null) {
      return Container(
        height: 50, // Adjust the height as needed
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return const Text("Ads"); // This will be a very simple placeholder.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(SubjectController(moduleId: widget.moduleId));
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    _loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
          title: Text(
            widget.moduleName,
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.025),
          ),
        ),
        body: Obx(() => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: controller.subject.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => QuestionScreen(
                          subjectId: controller.subject[index].id!,
                          subjectName: controller.subject[index].subjectName!,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.sp),
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(39, 25, 99, 1),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.subject[index].subjectName!,
                              style: TextStyle(
                                  fontSize: 20.sp, color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_right_alt,
                              size: 30.sp,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })));
    //  bottomNavigationBar: _buildBottomNavigationBar());
  }
}
