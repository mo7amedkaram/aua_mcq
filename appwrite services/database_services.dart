import 'package:appwrite/appwrite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppwriteDb {
  // this function responsible for check userData in database

  Future checkUserId({required String userId}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f'); // ==================> 1 done

    var documents = await await databases.listDocuments(
      databaseId: "65343991a4a9ab79fba9", // ==================> 2 done
      collectionId: "65ac5736d76070d8b547", // ==================> 3 done
      queries: [
        Query.equal("user_id", userId),
      ],
    );

    for (var document in documents.documents) {
      return document.data["user_id"];
    }
  }

//---------------------------------- get all userData -----
  Future getAllUserData({required String userId}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f'); // ==================> 4 done

    var documents = await await databases.listDocuments(
      databaseId: "65343991a4a9ab79fba9", // ==================> 5 done
      collectionId: "65ac5736d76070d8b547", // ==================> 6 done
      queries: [
        Query.equal("user_id", userId),
      ],
    );

    for (var document in documents.documents) {
      return document.data;
    }
  }

  //---------------------- store user data --------
  Future createDocument({
    required String userId,
    required String userName,
    required String userEmail,
    required String phoneNumber,
    required String deviceId,
  }) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    var document = await await databases.createDocument(
        databaseId: "65343991a4a9ab79fba9", // ==================> 7 done
        collectionId: "65ac5736d76070d8b547", // ==================> 8 done
        documentId: ID.unique(),
        data: {
          "user_id": userId,
          "user_name": userName,
          "user_email": userEmail,
          "user_phone_number": phoneNumber,
          "user_device_id": deviceId
        });
  }

  //-------------

//--------------------
  Future getUsersWithFilter(String userId, String subcategoryId) async {
    Client client = Client();
    Databases databases = Databases(client);
    final account = Account(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65490db0b6534bd99e01');

    try {
      var documents = await databases.listDocuments(
        databaseId: "65490ddae28178cc3551",
        collectionId: "6560f6f1e184767b8a4a",
        queries: [
          Query.equal("user_id", userId),
          Query.equal("subcategory_id", subcategoryId),
        ],
      );
      return documents.documents;
    } catch (error) {
      if (error is AppwriteException) {
        Fluttertoast.showToast(msg: error.response);
      }
    }
  }
}
