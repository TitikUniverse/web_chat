// ignore_for_file: depend_on_referenced_packages, curly_braces_in_flow_control_structures

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:web_chat/models/chat_model.dart';
import 'package:web_chat/repositories/messenger_repository.dart';

import '../../models/action_result.dart';
import '../room/room_bloc.dart';

part 'messenger_event.dart';
part 'messenger_state.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  final MessengerRepository _messengerRepository;
  final RoomBloc _roomBloc;

  final List<ChatModel> _chats = [];
  int? selectedChatId;

  ChatModel? getCurrentChat() {
    return _chats.firstWhereOrNull((element) => element.id == selectedChatId);
  }

  MessengerBloc(this._messengerRepository, this._roomBloc) : super(MessengerInitial()) {
    on<LoadChatsEvent>((event, emit) async {
      if (_chats.isEmpty) emit(const LoadingChatsState());

      int chatCount = 20;
      int chatSkipCount = event.chatsPageNumber * chatCount;

      ActionResult<List<ChatModel>> chatResponse = await _messengerRepository.getChats(chatCount, chatSkipCount);

      if (chatResponse.statusCode == 200) {
        emit(LoadChatsCompleteState(chatResponse.data!, selectedChatId));
        _chats.addAll(chatResponse.data!);
      }
      else emit(LoadChatsErrorState(chatResponse.responseText, chatResponse.statusCode));
    });

    on<SelectChatEvent>((event, emit) async {
      _roomBloc.saveStateToLocal(selectedChatId);
      selectedChatId = event.selectedChatId;
      emit(LoadChatsCompleteState(_chats, selectedChatId));
    });
  }
}
