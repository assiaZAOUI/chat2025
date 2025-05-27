import 'package:chat2025/models/ChatModel.dart';
import 'package:chat2025/services/ApiService.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModel}) async {
    // if (chosenModelId.toLowerCase().startsWith("gpt")) {
    //   chatList.addAll(await ApiService.sendMessageGPT(
    //     message: msg,
    //     modelId: chosenModelId,
    //   ));
    // } else if {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        model: chosenModel,
      ));
    //}
    notifyListeners();
    
  }

}