part of 'messenger_bloc.dart';

@immutable
abstract class MessengerState extends Equatable {
  const MessengerState();

  @override
  List<Object?> get props => [];
}

class MessengerInitial extends MessengerState {
  @override
  List<Object?> get props => [];
}

class LoadingChatsState extends MessengerState {
  const LoadingChatsState();

  @override
  List<Object?> get props => [];
}

class LoadChatsCompleteState extends MessengerState {
  final List<ChatModel> chats;
  final int? selectedChatId;

  const LoadChatsCompleteState(this.chats, this.selectedChatId);

  @override
  List<Object?> get props => [chats, selectedChatId];
}

class LoadChatsErrorState extends MessengerState {
  final String? message;
  final int? statusCode;

  const LoadChatsErrorState(this.message, this.statusCode);

  @override
  List<Object?> get props => [message, statusCode];
}