import 'package:aua_questions_app/view/module%20page/module_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Ads Helper/ads_helper.dart';
import '../Home Page/my_home_page.dart';
import '../Subjects Page/subject_page.dart';

class ModuleScreen extends StatefulWidget {
  ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
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

  Map<String, dynamic> data = Get.arguments;

  @override
  void initState() {
    // TODO: Load a banner ad
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
  Widget build(BuildContext context) {
    ModuleController controller =
        Get.put(ModuleController(gradeId: data["gradeId"]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
        title: Text(
          data["gradeName"],
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height * 0.025),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                ),
                itemCount: controller.modules.length,
                itemBuilder: (contex, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => SubjectPage(
                            moduleId: controller.modules[index].id!,
                            moduleName: controller.modules[index].moduleName!,
                          ));
                    },
                    child: ModuleContainer(
                      moduleName: controller.modules[index].moduleName!,
                      lottieImage: Image.network(
                        controller.modules[index].moduleImage!,
                      ),
                    ),
                  );
                },
              ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
