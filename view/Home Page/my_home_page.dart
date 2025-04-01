import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Ads Helper/ads_helper.dart';
import '../Favourite Screen/favourite_screen.dart';
import '../TestMe Screen/testme_screen.dart';
import '../module page/module_screen.dart';
import 'home_page_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomePageController controller = Get.put(HomePageController());

  final urlMohamed = Uri.parse("https://www.facebook.com/mo7amedtech");
  final urlMansour = Uri.parse(
      "https://www.facebook.com/Mansour.AlSayed.Algazar?mibextid=ZbWKwL");
  final urlAua = Uri.parse("https://t.me/AUA_Questions");

  Future<void> _launchUrl({required Uri url}) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: Load a banner ad
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FavouriteScreen());
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 40,
            ),
          ),
          SizedBox(
            width: 10.sp,
          ),
          IconButton(
            onPressed: () {
              // Fluttertoast.showToast(msg: "");
              /*
   Get.defaultDialog(
                title: "إزالة الإعلانات",
                titleStyle: TextStyle(fontFamily: "Tajawal"),
                content: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "إزالة جميع الإعلانات",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontFamily: "Tajawal", fontSize: 17.sp),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            height: 30.sp,
                            width: 30.sp,
                            child: Image.asset("assets/images/right_mark.png"),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "إستلام التحديثات قبل رفعها على المتجر",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Tajawal", fontSize: 17.sp),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            height: 30.sp,
                            width: 30.sp,
                            child: Image.asset("assets/images/right_mark.png"),
                          ),
                        ],
                      ),
                    ),
                    //----
                    SizedBox(
                      height: 10.sp,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "إضافتك في جروب تيليجرام للإستماع لمشاكلكم وحلها",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Tajawal", fontSize: 17.sp),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            height: 30.sp,
                            width: 30.sp,
                            child: Image.asset("assets/images/right_mark.png"),
                          ),
                        ],
                      ),
                    ),
                    //--------------
                    SizedBox(
                      height: 10.sp,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "يمكنك ترشيح صديق للحصول على نسخة مجاناً هدية",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Tajawal", fontSize: 17.sp),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            height: 30.sp,
                            width: 30.sp,
                            child: Image.asset("assets/images/right_mark.png"),
                          ),
                        ],
                      ),
                    ),
                    //-------------
                    SizedBox(
                      height: 10.sp,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "إشعارات مخصصة",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Tajawal", fontSize: 17.sp),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Container(
                            height: 30.sp,
                            width: 30.sp,
                            child: Image.asset("assets/images/right_mark.png"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Center(
                      child: Text(
                        "سعر النسخة هو 100 جنيه مصري \n أو 5\$ على بايبال",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 15.sp, fontFamily: "Tajawal"),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 3, 50, 88),
                          )),
                          onPressed: () {
                            _launchUrl(url: urlAua);
                          },
                          child: Text(
                            "اضغط للشراء",
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontSize: 18.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          )),
                    )
                  ],
                ),
              );
            

           */
            },
            icon: Container(
              width: 35.sp,
              height: 35.sp,
              child: Image.asset("assets/images/premium.png"),
            ),
          ),
        ],
        title: Text(
          "AUA Question",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage("assets/images/profile.png"),
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello, Doctor",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Text(
                                      "Level 1 * Beginer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                        0.9.sp <
                                                    400.sp
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9.sp
                                                : 400.sp,
                                        constraints: BoxConstraints(),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: IntrinsicHeight(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.sp),
                                                child: Center(
                                                  child: Text(
                                                    "تمت برمجة التطبيق بالكامل بواسطة كلا من",
                                                    style: TextStyle(
                                                      fontFamily: "Tajawal",
                                                      color: Colors.black,
                                                      fontSize: 18.sp,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.sp),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _launchUrl(
                                                            url: urlMansour);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Icon(
                                                              Icons.arrow_back),
                                                          Text(
                                                            "د. منصور الجزار ",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Tajawal",
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    InkWell(
                                                      onTap: () {
                                                        _launchUrl(
                                                            url: urlMohamed);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Icon(
                                                              Icons.arrow_back),
                                                          Text(
                                                            "محمد كرم",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Tajawal",
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: 24.sp,
                                // ignore: sort_child_properties_last
                                child: Lottie.asset('assets/images/about.json'),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28.sp,
                        ),
                        InkWell(
                          onTap: () => Get.to(() => TestMeScreen()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.sp),
                            child: Image.asset("assets/images/testme.png"),
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 27.sp, left: 27.sp, right: 27.sp),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose Your Grade : ",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Obx(
                              () => controller.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.75,
                                      ),
                                      itemCount: controller.grades.length,
                                      itemBuilder: (contex, index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(ModuleScreen(), arguments: {
                                              "gradeName": controller
                                                  .grades[index].gradeName!,
                                              "gradeId":
                                                  controller.grades[index].id,
                                            });
                                          },
                                          child: ModuleContainer(
                                            moduleName: controller
                                                .grades[index].gradeName!,
                                            lottieImage: Image.network(
                                              controller
                                                  .grades[index].gradePicture!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleContainer extends StatelessWidget {
  final String moduleName;
  final lottieImage;

  const ModuleContainer(
      {super.key, required this.moduleName, required this.lottieImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(6.sp),
            height: 175.sp,
            width: 200.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: Color.fromRGBO(39, 25, 99, 1)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100.sp,
                    height: 100.sp,
                    child: lottieImage,
                  ),
                  Text(
                    moduleName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
