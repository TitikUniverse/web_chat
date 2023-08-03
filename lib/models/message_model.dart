import 'dart:convert';

import 'user_info_model.dart';


List<MessageModel> userMessgesFromJson(String str) => List<MessageModel>.from(json.decode(str).map((x) => MessageModel.fromJson(x)));
String userMessgesToJson(List<MessageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

enum MessageStatus {
  needSent,
  sent,
  errorSent,
  ok
}

class MessageModel {
    MessageModel({
        this.id,
        required this.createTime,
        required this.chatId,
        required this.author,
        this.isRead = false,
        required this.content,
        this.isDelete,
        this.contentType,
        this.replyMessageId,
        this.replyMessage,
        this.status
    });

    int? id;
    final DateTime createTime;
    final int chatId;
    final UserInfoModel author;
    bool? isRead;
    String content;
    bool? isDelete;
    String? contentType;
    int? replyMessageId;
    MessageModel? replyMessage;
    MessageStatus? status;

    factory MessageModel.fromRawJson(String str) => MessageModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        createTime: DateTime.parse(json["createTime"]),
        chatId: json["chatId"],
        author: UserInfoModel.fromJson(json["author"]),
        isRead: json["isRead"],
        content: json["content"],
        isDelete: json["isDelete"],
        contentType: json["contentType"],
        replyMessageId: json["replyMessageId"],
        replyMessage: json["replyMessage"] != null ? MessageModel.fromJson(json["replyMessage"]) : null
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createTime": createTime.toIso8601String(),
        "chatId": chatId,
        "author": author.toJson(),
        "isRead": isRead,
        "content": content,
        "isDelete": isDelete,
        "contentType": contentType,
        "replyMessageId": replyMessageId,
        "replyMessage": replyMessage
    };
}
