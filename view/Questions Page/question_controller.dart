import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Question Model/question_model.dart';

class QuestionController extends GetxController {
  var isLoading = false.obs;
  final subjectId;
  var defaultBg = Color.fromRGBO(39, 25, 99, 1);
  var rightAnswer = Colors.green;
  var falseAnswer = Colors.red;
  Map<String, int> currentPages = {};

  List<List<Color>> allButtonColors = [];
  var question = <QuestionModel>[].obs;
  var questionsTest = <QuestionModel>[].obs;
  //--------

  // لحفظ رقم الصفحة الحالية في التخزين المحلي

  //----------
  Future<void> storeButtonColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorsData = allButtonColors.asMap().entries.map((entry) {
      int index = entry.key;
      List<Color> colors = entry.value;
      String questionId =
          question[index].id ?? ""; // افترض أن لديك معرف لكل سؤال
      return {
        "questionId": questionId,
        "colors": colors.map((color) => color.value.toString()).toList(),
      };
    }).toList();
    prefs.setString('buttonColors_$subjectId', jsonEncode(colorsData));
  }

  Future<void> loadButtonColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorsData = prefs.getString('buttonColors_$subjectId');
    if (colorsData != null) {
      final List<dynamic> loadedColors = jsonDecode(colorsData);
      allButtonColors = loadedColors.map((data) {
        String savedQuestionId = data["questionId"];
        List<Color> colors = (data["colors"] as List).map((color) {
          return Color(int.parse(color));
        }).toList();
        for (var questionModel in question) {
          if (questionModel.id == savedQuestionId) {
            return colors;
          }
        }
        return List.filled(colors.length, defaultBg);
      }).toList();
    }
  }
  //-------------

  //--------------

  //-----------------
  QuestionController({
    this.subjectId,
  });

  //---------

  Future<void> getQuestions() async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      int offset = 0; // بدء الاسترجاع من العنصر الأول
      List<QuestionModel> allDocuments = [];

      while (true) {
        final response = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '6535a638bcc1fdb13187',
          queries: [
            Query.equal("subject_id", subjectId),
            Query.limit(
                25), // الحد الأقصى للعناصر التي يمكن جلبها في استدعاء واحد
            Query.offset(offset),
          ],
        );

        if (response.documents.isEmpty) {
          break;
        }

        allDocuments.addAll(
            response.documents.map((e) => QuestionModel.fromJson(e.data)));
        offset += response.documents.length;
      }

      if (allDocuments.isNotEmpty) {
        question.clear();
        allButtonColors.clear();
      }

      for (var questionModel in allDocuments) {
        question.add(questionModel);
        allButtonColors
            .add(List.filled(questionModel.options!.length, defaultBg));
      }

      print("Total Questions Loaded: ${question.length}");
      print("Total Button Colors Loaded: ${allButtonColors.length}");
    } catch (e) {
      print("Failed to fetch questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

//-----------------------
  Future<void> getTestQuestions({required String subjectTestId}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      int offset = 0; // بدء الاسترجاع من العنصر الأول
      List<QuestionModel> allDocuments = [];

      while (true) {
        final response = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '6535a638bcc1fdb13187',
          queries: [
            Query.equal("subject_id", subjectTestId),
            Query.limit(
                25), // الحد الأقصى للعناصر التي يمكن جلبها في استدعاء واحد
            Query.offset(offset),
          ],
        );

        if (response.documents.isEmpty) {
          break;
        }

        allDocuments.addAll(
            response.documents.map((e) => QuestionModel.fromJson(e.data)));
        offset += response.documents.length;
      }

      if (allDocuments.isNotEmpty) {
        questionsTest.clear();
        allButtonColors.clear();
      }

      for (var questionModel in allDocuments) {
        questionsTest.add(questionModel);
        allButtonColors
            .add(List.filled(questionModel.options!.length, defaultBg));
      }
    } catch (e) {
      print("Failed to fetch questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //----------- send wrong answer -------

  Future<void> sendWrongAnswer(
      {required String questionId,
      required String questionTitle,
      required String description}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      var wrong = await databases.createDocument(
        databaseId: "65343991a4a9ab79fba9",
        collectionId: "654780d9443608914100",
        documentId: ID.unique(),
        data: {
          "question_id": questionId,
          "question_title": questionTitle,
          "description": description,
        },
      );
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
