import 'dart:math';

import 'package:chat2025/constants/constants.dart';
import 'package:chat2025/models/ChatModel.dart';
import 'package:chat2025/providers/ModelsProvider.dart';
import 'package:chat2025/providers/ChatProvider.dart';
import 'package:chat2025/services/ApiService.dart';
import 'package:chat2025/services/AssetsManager.dart';
import 'package:chat2025/services/ChatServices.dart';
import 'package:chat2025/services/UserService.dart';
import 'package:chat2025/widgets/ChatWidget.dart';
import 'package:chat2025/widgets/TextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false; // Variable pour gérer l'état de la saisie
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  //List<ChatModel> chatList = [];
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        appBarTheme: AppBarTheme(color: cardColor),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo),
          ),
          title: const Text(
            "ChatGPT",
            style: TextStyle(color: Colors.white), // Titre en blanc
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await ChatServices.showModalSheet(context: context);
              },
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                await UserService().logout(); // Déconnexion
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                //Sans Expanded, ListView.builder essaie de s'étendre indéfiniment
                //, ce qui n'est pas possible dans une Column qui ne lui impose
                // pas de contraintes de taille.
                //Expanded permet de prendre tout l'espace disponible
                //dans la colonne, ce qui est nécessaire pour que ListView.builder
                child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg:
                          chatProvider
                              .chatList[index]
                              .msg, //chatList[index].msg,
                      chatIndex:
                          chatProvider
                              .getChatList[index]
                              .chatIndex, //chatList[index].chatIndex,
                    );
                  },
                ),
              ),
              if (_isTyping) ...[
                const SpinKitThreeBounce(color: Colors.white, size: 18),
              ],
              const SizedBox(height: 15),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider,
                            );
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scrollListToEND() {
    // Scroll vers le bas de la liste
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    final message = textEditingController.text.trim();
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "Please type a message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: message);
        textEditingController.clear();
        focusNode.unfocus();
      });

      await chatProvider.sendMessageAndGetAnswers(
        msg: message,
        chosenModel: modelsProvider.getCurrentModel,
      );
    } catch (error) {
      print("Erreur dans sendMessage: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(label: error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
