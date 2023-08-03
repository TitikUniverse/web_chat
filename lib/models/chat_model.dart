import 'dart:convert';

import 'message_model.dart';
import 'user_info_model.dart';

List<ChatModel> userChatsFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String userChatsToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
    ChatModel({
        this.id,
        required this.interlocutor,
        this.lastMessage,
        this.tags,
        this.lastInterlocutorMessageIsRead,
        this.unreadMessagesCount = 0
    });

    final int? id;
    final UserInfoModel interlocutor;
    final List<String>? tags;
    MessageModel? lastMessage;
    bool? lastInterlocutorMessageIsRead;
    int unreadMessagesCount;

    factory ChatModel.fromRawJson(String str) => ChatModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        interlocutor: UserInfoModel.fromJson(json["interlocutor"]),
        tags: json["tags"] != null ? List<String>.from(json["tags"].map((x) => x)) : null,
        lastMessage: json["lastMessage"] != null ? MessageModel.fromJson(json["lastMessage"]) : null,
        lastInterlocutorMessageIsRead: json["lastInterlocutorMessageIsRead"] ?? false,
        unreadMessagesCount: json["unreadMessagesCount"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "interlocutor": interlocutor.toJson(),
        "lastMessage": lastMessage != null ? lastMessage!.toJson() : null,
        "tags": tags != null ? List<dynamic>.from(tags!.map((x) => x)) : null,
        "lastInterlocutorMessageIsRead": lastInterlocutorMessageIsRead,
        "unreadMessagesCount": unreadMessagesCount
    };
}