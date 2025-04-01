import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'Ads Helper/ads_helper.dart';
import 'view/Home Page/my_home_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:appwrite/appwrite.dart';

import 'view/SignIn_screen.dart/sign_in_screen.dart';
import 'view/check updates/check_updates.dart';

PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
  installerStore: 'Unknown',
);

Future<void> _initPackageInfo() async {
  final info = await PackageInfo.fromPlatform();
  _packageInfo = info;
}

var isLoading = false.obs;
String? myAppVersion;
Future<void> getAppVersion() async {
  Client client = Client();
  Databases databases = Databases(client);

  client
      .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
      .setProject('65f463fd706dd4b9b48f');

  try {
    isLoading.value = true;
    final appVersion = await databases.listDocuments(
      databaseId: '65343991a4a9ab79fba9',
      collectionId: '65c04ad2cc57aa25db07',
    );
    myAppVersion = appVersion.documents[0].data["data"];
    //  print();
  } catch (e) {
    throw Exception("Failed to fetch services: $e");
  } finally {
    isLoading.value = false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getAppVersion().then((value) => _initPackageInfo());
  OneSignal.initialize("2f595087-d108-463a-80ee-a2480eff201c");
  OneSignal.Notifications.requestPermission(true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  AppOpenAd? appOpenAd;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.openAppAd,
      request: const AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            appOpenAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          //  print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initGoogleMobileAds();
    loadAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    if (appOpenAd != null) {
      appOpenAd!.show().then((value) => ScreenUtilInit(
            designSize: const Size(360, 690),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: "Tajawal",
                primarySwatch: Colors.blue,
                appBarTheme: const AppBarTheme(
                    iconTheme: IconThemeData(color: Colors.white)),
              ),
              home: myAppVersion == _packageInfo.version
                  ? MyHomePage()
                  : CheckUpdates(),
            ),
          ));
    }
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Cairo",
          primarySwatch: Colors.blue,
          appBarTheme:
              const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        ),
        home: myAppVersion == _packageInfo.version
            ? SignInScreen()
            : CheckUpdates(),
      ),
    );
  }
}



/*
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Cairo",
          primarySwatch: Colors.blue,
          appBarTheme:
              const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        ),
        home: MyHomePage(),
      ),
    );
  }

  */

