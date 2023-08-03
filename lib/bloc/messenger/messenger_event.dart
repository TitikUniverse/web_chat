part of 'messenger_bloc.dart';

@immutable
abstract class MessengerEvent extends Equatable {}

class LoadChatsEvent extends MessengerEvent {
  final int chatsPageNumber;

  LoadChatsEvent(this.chatsPageNumber);

  @override
  List<Object?> get props => [chatsPageNumber];
}

class SelectChatEvent extends MessengerEvent {
  final int selectedChatId;

  SelectChatEvent(this.selectedChatId);

  @override
  List<Object?> get props => [selectedChatId];
}