part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  const RoomState();
  
  @override
  List<Object?> get props => [];
}

class RoomInitialState extends RoomState {}

class RoomLoadingState extends RoomState {
  const RoomLoadingState();

  @override
  List<Object?> get props => [];
}

class RoomLoadingCompleteState extends RoomState {
  const RoomLoadingCompleteState(this.messages);

  final List<MessageModel> messages;

  @override
  List<Object?> get props => [messages];
}

class RoomLoadingErrorState extends RoomState {
  const RoomLoadingErrorState(this.message, this.statusCode);

  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
