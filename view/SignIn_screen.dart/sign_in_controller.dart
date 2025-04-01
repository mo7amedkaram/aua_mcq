import 'package:appwrite/appwrite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../../appwrite services/database_services.dart';
import '../../appwrite services/login_services.dart';
import '../Home Page/my_home_page.dart';
import 'sign_in_screen.dart';

class SignInController extends GetxController {
  AppwriteAuth appwriteAuth = AppwriteAuth();
  AppwriteDb appwriteDb = AppwriteDb();
  var isLoading = false.obs;

  void login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      var response = await appwriteAuth.createEmailSession(
          email: email, password: password);

      var checkUserId = await appwriteDb.checkUserId(userId: response.userId);
      var accountInfo =
          await appwriteAuth.getAccountInformation(); // Await the result here

      storeUserData(
        checkUserId: checkUserId,
        phoneNumber: accountInfo.phone,
        userEmail: accountInfo.email,
        userId: accountInfo.$id,
        userName: accountInfo.name,
      );

      // method to check if user store in database
    } catch (error) {
      if (error is AppwriteException) {
        if (error.response != null && error.response['code'] == 401) {
          Fluttertoast.showToast(
              msg: "كلمة المرور أو الإيميل غير صحيحة راجع بياناتك");
        } else if (error.response != null && error.response['code'] == 429) {
          Fluttertoast.showToast(
              msg:
                  "لقد تم حظرك من تسجيل الدخول لمدة ساعتين راجع التسجيل بعدها");
        } else if (error.response != null && error.response['code'] == 400) {
          Fluttertoast.showToast(
              msg: "يجب أن يكون الإيميل صحيح وكلمة المرور فوق ال8 أحرف");
        } else if (error.response != null && error.response['code'] == 500) {
          Fluttertoast.showToast(
              msg: "مشكلة في السيرفر برجاء الإنتظار بعض الوقت");
        } else {
          Fluttertoast.showToast(msg: "${error.response}");
        }
      } else {
        Fluttertoast.showToast(msg: error.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

//------

// this function used to store user data if not existed
  void storeUserData({
    required dynamic checkUserId,
    required String userId,
    required String userName,
    required String userEmail,
    required String phoneNumber,
  }) async {
    String? deviceId = await MobileDeviceIdentifier().getDeviceId();
    if (checkUserId == null) {
      Fluttertoast.showToast(msg: "جاري تخزين البيانات");

      await appwriteDb
          .createDocument(
            userId: userId,
            userName: userName,
            userEmail: userEmail,
            phoneNumber: phoneNumber,
            deviceId: deviceId!,
          )
          .then((value) => Get.offAll(() => MyHomePage()));
      Fluttertoast.showToast(msg: "تم بنجاح يمكنك تسجيل الدخول الآن");
    } else {
      Fluttertoast.showToast(
          msg: "تم التعرف على حسابك, جاري التأكد من نوع الجهاز");

      dynamic allUserData = await appwriteDb.getAllUserData(userId: userId);

      var _userId = allUserData["user_id"];
      var _userDeviceId = allUserData["user_device_id"];

      if (_userId == userId && _userDeviceId == deviceId) {
        Fluttertoast.showToast(msg: "تم التحقق جاري تسجيل الدخول");
        Get.offAll(() => MyHomePage());
      } else {
        await appwriteAuth.logOut().then((value) => Fluttertoast.showToast(
                msg: "عذرا الجهاز غير متطابق, جاري تسجيل الخروج")
            .then((value) => Get.offAll(() => SignInScreen())));
      }
    }
  }

  // this function responsible for save user data
}
