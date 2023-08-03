// ignore_for_file: unnecessary_string_escapes

import 'dart:math';

import 'package:get/get.dart';
import 'package:web_chat/models/action_result.dart';
import 'package:web_chat/models/chat_model.dart';
import 'package:web_chat/models/message_model.dart';

class MessengerRepository extends GetxService {
  Future<ActionResult<List<ChatModel>>> getChats(int count, int skipCount) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return ActionResult(
        data: userChatsFromJson(testChatsData),
        statusCode: 200,
        responseText: null
      );
    } catch (e) {
      return ActionResult(
        data: null,
        statusCode: 500,
        responseText: 'Произошла ошибка. Попробуйте ещё раз'
      );
    }
  }

  Future<ActionResult<List<MessageModel>>> getChatMessages(int chatId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return ActionResult(
        data: userMessgesFromJson(testMessagesData),
        statusCode: 200,
        responseText: null
      );
    } catch (e) {
      return ActionResult(
        data: null,
        statusCode: 500,
        responseText: 'Произошла ошибка. Попробуйте ещё раз'
      );
    }
  }

  MessageModel getRandomMessage() {
    List<MessageModel> data = userMessgesFromJson(testAdditionalMessages);
    int randomIndex = Random().nextInt(data.length);
    return data[randomIndex];
  }
}

String testChatsData = '''
[
{"id":5,"tags":["Тег 1", "Тег 2"],"interlocutor":{"id":1,"nickname":"titikuniverse","email":"titikuniverse@gmail.com","name":"Семён Титов","description":"Программист, основатель Potok Автор игр Flat Planet и Space Live Evolution Мои песни - Titik","linkInBio":"vk.com/titikuniverse","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/k0xewixh.xgz.jpg"},"lastMessage":{"id":4492,"createTime":"2023-07-18T20:34:51.026695Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"😮🤗😻😻😻🤮🤮🤮😻🫠🫠","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},"lastInterlocutorMessageIsRead":true,"unreadMessagesCount":3},
{"id":6,"interlocutor":{"id":106,"nickname":"Howtobe","email":"","name":null,"description":"Ютубер, программист, мини художник, люблю играть","linkInBio":"https://youtube.com/@howtobe4617","isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/yuoz4w2w.v5b.png"},"lastMessage":{"id":4134,"createTime":"2023-06-15T11:40:10.438434Z","chatId":6,"author":{"id":106,"nickname":"Howtobe","email":"","name":null,"description":"Ютубер, программист, мини художник, люблю играть","linkInBio":"https://youtube.com/@howtobe4617","isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/yuoz4w2w.v5b.png"},"isRead":true,"content":"Привет","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},"lastInterlocutorMessageIsRead":true,"unreadMessagesCount":0},
{"id":76,"interlocutor":{"id":33,"nickname":"Alex","email":"ak106mail@gmail.com","name":"Александр","description":"Сооснователь социальной сети Potok 😎","linkInBio":"potok.online/alex","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/eurkalzu.0s4.jpg"},"lastMessage":{"id":2467,"createTime":"2022-10-16T17:32:15.090452Z","chatId":76,"author":{"id":33,"nickname":"Alex","email":"ak106mail@gmail.com","name":"Александр","description":"Сооснователь социальной сети Potok 😎","linkInBio":"potok.online/alex","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/eurkalzu.0s4.jpg"},"isRead":true,"content":"Чат","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},"lastInterlocutorMessageIsRead":true,"unreadMessagesCount":0},
{"id":40,"interlocutor":{"id":37,"nickname":"AcruxTech","email":"","name":"Владимир ","description":"Я крутой 😎","linkInBio":"","isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/5jc5k3yl.tui.jpg"},"lastMessage":{"id":574,"createTime":"2022-08-05T19:11:32.270150Z","chatId":40,"author":{"id":37,"nickname":"AcruxTech","email":"","name":"Владимир ","description":"Я крутой 😎","linkInBio":"","isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/5jc5k3yl.tui.jpg"},"isRead":true,"content":"тест сообщений","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},"lastInterlocutorMessageIsRead":true,"unreadMessagesCount":0}
]
''';

String testMessagesData =  '''
[
  {"id":4490,"createTime":"2023-07-18T20:33:41.821912Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"💩💩💩💩💩💩💩💩💩💩","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4665,"createTime":"2023-08-02T15:24:17.891942Z","chatId":5,"author":{"id":1,"nickname":"titikuniverse","email":"titikuniverse@gmail.com","name":"Семён Титов","description":"Программист, основатель Potok Автор игр Flat Planet и Space Live Evolution Мои песни - Titik","linkInBio":"vk.com/titikuniverse","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/k0xewixh.xgz.jpg"},"isRead":false,"content":"Привет","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4494,"createTime":"2023-07-18T20:33:41.821912Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"💩💩💩💩💩💩💩💩💩💩","isDelete":null,"contentType":"text","replyMessageId":4665,"replyMessage": {"id":4665,"createTime":"2023-08-02T15:24:17.891942Z","chatId":5,"author":{"id":1,"nickname":"titikuniverse","email":"titikuniverse@gmail.com","name":"Семён Титов","description":"Программист, основатель Potok Автор игр Flat Planet и Space Live Evolution Мои песни - Titik","linkInBio":"vk.com/titikuniverse","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/k0xewixh.xgz.jpg"},"isRead":false,"content":"Привет","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null}},
  {"id":4638,"createTime":"2023-08-02T15:24:17.891942Z","chatId":5,"author":{"id":1,"nickname":"titikuniverse","email":"titikuniverse@gmail.com","name":"Семён Титов","description":"Программист, основатель Potok Автор игр Flat Planet и Space Live Evolution Мои песни - Titik","linkInBio":"vk.com/titikuniverse","isDeleted":false,"isVerifiedProfile":true,"isAuthorOfQualityContent":false,"avatarUrl":"https://ratemeapp.hb.bizmrg.com/userdata/avatars/k0xewixh.xgz.jpg"},"isRead":false,"content":"Как дела?","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null}
]
''';

String testAdditionalMessages = '''
[
  {"id":4492,"createTime":"2023-07-18T20:34:51.026695Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Хочу вам пооветовать купить нашу туалетную воду с изысканным ароматом","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4491,"createTime":"2023-07-18T20:34:25.886794Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Для вас скидка в размере 49%","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4491,"createTime":"2023-07-18T20:34:25.886794Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Хотим предложить вам персноальные условия по обслуживанию","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4491,"createTime":"2023-07-18T20:34:25.886794Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Оставьте отзыв и получите скидку!","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4491,"createTime":"2023-07-18T20:34:25.886794Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Только сегодня у нас распродажа остатков склада со скидками до 70%","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null},
  {"id":4490,"createTime":"2023-07-18T20:34:14.521849Z","chatId":5,"author":{"id":2,"nickname":"test","email":null,"name":null,"description":null,"linkInBio":null,"isDeleted":false,"isVerifiedProfile":false,"isAuthorOfQualityContent":false,"avatarUrl":null},"isRead":true,"content":"Хочу предлодить вам рассмотреть покупку 400 роз со скидкой 10% и бесплатной доставкой","isDelete":null,"contentType":"text","replyMessageId":null,"replyMessage":null}
]
''';