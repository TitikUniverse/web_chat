import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_chat/bloc/messenger/messenger_bloc.dart';
import 'package:web_chat/bloc/room/room_bloc.dart';
import 'package:web_chat/extensions/date_time_extension.dart';

import '../../models/chat_model.dart';
import '../../theme/my_theme.dart';

class ChatsWidget extends StatelessWidget {
  const ChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MessengerBloc, MessengerState>(
            buildWhen: (previous, current) {
              if (previous is LoadChatsCompleteState) {
                if (current is LoadChatsCompleteState) return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is LoadingChatsState) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              else if (state is LoadChatsCompleteState) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: state.chats.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ChatRoomItem(
                      chat: state.chats[index],
                      isSelected: state.selectedChatId == state.chats[index].id,
                    );
                  },
                );
              }
              else if (state is LoadChatsErrorState) {
                return Center(
                child: Text(state.message ?? 'Произошла ошибка'),
              );
              }
              return const Center(
                child: Text('Bad State'),
              );
            },
          ),
        )
      ],
    );
  }
}

class ChatRoomItem extends StatelessWidget {
  const ChatRoomItem({
    super.key,
    required this.chat,
    required this.isSelected,
  });

  final ChatModel chat;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<MessengerBloc>().add(SelectChatEvent(chat.id!));
        context.read<RoomBloc>().add(LoadRoomEvent(chat.id!));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? MyTheme.of(context).brandColor.withOpacity(0.05) : null,
        ),
        // foregroundDecoration: BoxDecoration(
        //   border: isSelected ? Border(
        //           left: BorderSide(
        //             color: MyTheme.of(context).brandColor,
        //             width: 4,
        //           ),
        //         )
        //       : null,
        // ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: Stack(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: chat.interlocutor.avatarUrl != null ? NetworkImage(
                                    chat.interlocutor.avatarUrl!,
                                  ) : const AssetImage('assets/images/noavatar.png') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // if (chat.isOnline)
                            //   Align(
                            //     alignment: Alignment.bottomRight,
                            //     child: Container(
                            //       height: 12,
                            //       width: 12,
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.green,
                            //         border: Border.all(
                            //           color: Colors.white,
                            //           width: 2,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chat.interlocutor.name ?? chat.interlocutor.nickname,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (chat.tags != null && chat.tags!.isNotEmpty) Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: 25,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: chat.tags!.length,
                                separatorBuilder:(context, index) => const SizedBox(width: 10), 
                                itemBuilder: (context, index) => Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: MyTheme.of(context).brandColor,
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Text(
                                    chat.tags![index],
                                    style: TextStyle(
                                      color: MyTheme.of(context).textColor,
                                      fontSize: 10
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              chat.lastMessage!.content,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chat.lastMessage!.createTime.toTimeFormat,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            visible: chat.unreadMessagesCount > 0,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            child: Container(
                              width: 40,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: MyTheme.of(context).brandColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(
                                chat.unreadMessagesCount.toString(),
                                style: TextStyle(
                                  color: MyTheme.of(context).textColor
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
