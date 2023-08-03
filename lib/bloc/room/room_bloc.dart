import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_chat/main.dart';
import 'package:web_chat/models/current_user.dart';

import '../../models/action_result.dart';
import '../../models/message_model.dart';
import '../../repositories/messenger_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final MessengerRepository _messengerRepository;

  List<MessageModel> messages = [];

  void saveStateToLocal(int? selectedChatId) {
    if (selectedChatId == null) return;

    MyApp.prefs.setString(selectedChatId.toString(), userMessgesToJson(messages));
  }

  RoomBloc(this._messengerRepository) : super(RoomInitialState()) {
    on<LoadRoomEvent>((event, emit) async {
      messages.clear();
      emit(const RoomLoadingState());

      ActionResult<List<MessageModel>> response = await _messengerRepository.getChatMessages(event.chatId);

      if (response.statusCode == 200) {
        emit(RoomLoadingCompleteState(response.data!.reversed.toList()));
        messages.addAll(response.data!.reversed.toList());

        // Эмитация получения сообщений
        for (int i = 0; i < 3; i++) {
          await Future.delayed(const Duration(seconds: 1));
          emit(const RoomLoadingState());
          messages.insert(0, _messengerRepository.getRandomMessage());
          emit(RoomLoadingCompleteState(messages));
        }
      }
      else {
        emit(RoomLoadingErrorState(response.responseText, response.statusCode));
      }
    });

    on<AddNewMessage>((event, emit) async {
      emit(const RoomLoadingState());
      MessageModel newMessage = MessageModel(
        createTime: DateTime.now(),
        chatId: event.chatId,
        author: CurrentUser.currentUser,
        content: event.messageText,
        contentType: 'text'
      );
      messages.add(newMessage);
      emit(RoomLoadingCompleteState(messages));
    });
  }
}
