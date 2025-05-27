import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat2025/constants/ApiConstants.dart';
import 'package:chat2025/models/ChatModel.dart';
import 'package:chat2025/models/ModelsModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  ///  Modèles gratuits DeepSeek via OpenRouter
  static Future<List<String>> getFreeModels() async {
    try {
      final List<Map<String, dynamic>> rawModels = [
        {"model": "deepseek/deepseek-prover-v2:free"},
        {"model": "deepseek/deepseek-v3-base:free"},
        {"model": "deepseek/deepseek-r1-zero:free"},
        {"model": "deepseek/deepseek-r1-distill-qwen-32b:free"},
        {"model": "deepseek/deepseek-r1-distill-llama-70b:free"},
      ];

      // Extraire juste les noms des modèles
      return rawModels.map((e) => e['model'].toString()).toList();
    } catch (error) {
      log("Erreur dans getFreeModels: $error");
      rethrow;
    }
  }

  /// Envoi d'un message via OpenRouter
  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String model,
  }) async {
    try {
      log("model: $model");
      // if (apiKey == null) throw Exception("OPENROUTER_API_KEY non défini");

      //log("Utilisation du modèle : $model");

      var response = await http.post(
        Uri.parse("$BASE_URL"),
        headers: {
          'Authorization': 'Bearer $OPENROUTER_API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": model,
          //reponse complete
          "messages": [
            {"role": "user", "content": message},
          ],
          "max_tokens": 300,
        }),
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      final choices = jsonResponse["choices"];
      List<ChatModel> chatList = [];
      if (choices.length > 0) {
        //log(
        //  "jsonResponse[choices]text ${jsonResponse["choices"][0]["message"]["content"]}",
        //);
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1, // c le bot
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("Erreur dans sendMessage: $error");
      rethrow;
    }
  }
}
