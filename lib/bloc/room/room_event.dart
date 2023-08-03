part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class LoadRoomEvent extends RoomEvent {
  final int chatId;

  const LoadRoomEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class AddNewMessage extends RoomEvent {
  final String messageText;
  final int chatId;

  const AddNewMessage(this.messageText, this.chatId);

  @override
  List<Object> get props => [messageText, chatId];
}