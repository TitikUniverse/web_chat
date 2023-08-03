import 'dart:convert';

List<UserInfoModel> userInfoModelFromJson(String str) => List<UserInfoModel>.from(json.decode(str).map((x) => UserInfoModel.fromJson(x)));

String userInfoModelToJson(List<UserInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class UserInfoModel {
    UserInfoModel({
        required this.id,
        required this.nickname,
        this.name,
        this.description,
        this.linkInBio,
        required this.isDeleted,
        this.isFriend,
        this.avatarUrl,
    });

    final int id;
    final String nickname;
    final String? name;
    final String? description;
    final String? linkInBio;
    final bool isDeleted;
    final bool? isFriend;
    String? avatarUrl;

    factory UserInfoModel.fromRawJson(String str) => UserInfoModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        id: json["id"],
        nickname: json["nickname"],
        name: json["name"],
        description: json["description"],
        linkInBio: json["linkInBio"],
        isDeleted: json["isDeleted"],
        isFriend: json["isFriend"],
        avatarUrl: json["avatarUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "name": name,
        "description": description,
        "linkInBio": linkInBio,
        "isDeleted": isDeleted,
        "avatarUrl": avatarUrl,
    };
}
