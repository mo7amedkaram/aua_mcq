import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppwriteAuth {
  // this function responsible for check user existed

  Future<Session> createEmailSession(
      {required String email, required String password}) async {
    Client client = Client();
    Account account = Account(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');
    Fluttertoast.showToast(msg: "جاري تسجيل الدخول");
    return await account.createEmailSession(email: email, password: password);
  }

  Future getAccountInformation() async {
    Client client = Client();
    Account account = Account(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');
    Fluttertoast.showToast(msg: "جاري التحقق من حسابك");

    return await account.get();
  }

  // sign out from app
  Future logOut() async {
    Client client = Client();
    Account account = Account(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');
    Fluttertoast.showToast(msg: "جاري التحقق من حسابك");

    return await account.deleteSessions();
  }
  /*
  var isLoading = false.obs;
  //---------
  Future loginWithEmail({
    required String email,
    required String password,
  }) async {
    Client client = Client();
    Account account = Account(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('64d808f24c59a51adea8');

    try {
      isLoading.value = true;

      var session =
          await account.createEmailSession(email: email, password: password);
      Get.offAllNamed("/homePageScreen");

      Fluttertoast.showToast(msg: "نجح");
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
        print(error.response);
      } else {
        Fluttertoast.showToast(msg: error.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }




  */
}
