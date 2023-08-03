import 'package:web_chat/models/user_info_model.dart';

class CurrentUser {
  static UserInfoModel currentUser = UserInfoModel(
    id: 1,
    nickname: 'titikuniverse',
    name: 'Семён',
    isDeleted: false,
    avatarUrl: 'https://ratemeapp.hb.bizmrg.com/userdata/avatars/k0xewixh.xgz.jpg'
  );
}