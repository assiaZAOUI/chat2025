class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});

  // Factory pour créer depuis la réponse JSON OpenRouter
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatIndex: json["id"],
      // c la route du modele
      msg: json["model"],
    );
  }
}
