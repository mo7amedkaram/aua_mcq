import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'constants/colors.dart';

import 'utils/app_ad_manager.dart';
import 'utils/app_version_services.dart';
import 'view/Home Page/my_home_page.dart';
import 'view/check updates/check_updates.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MobileAds
  await MobileAds.instance.initialize();

  // Initialize OneSignal
  OneSignal.initialize("2f595087-d108-463a-80ee-a2480eff201c");
  OneSignal.Notifications.requestPermission(true);

  // Get app version info
  final appVersionService = AppVersionService();
  await appVersionService.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppAdManager _adManager = AppAdManager();

  @override
  void initState() {
    super.initState();
    _adManager.loadOpenAd(onAdLoaded: (ad) {
      ad.show();
    });
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AUA Questions',
        theme: ThemeData(
          fontFamily: "Cairo",
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.primary,
          appBarTheme: const AppBarTheme(
            color: AppColors.primary,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 2,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: _shouldShowUpdateScreen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            final needsUpdate = snapshot.data ?? false;
            return HomePage();
          },
        ),
      ),
    );
  }

  Future<bool> _shouldShowUpdateScreen() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersionService = Get.put(AppVersionService());

    return appVersionService.latestVersion != packageInfo.version;
  }
}
