import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_chat/bloc/messenger/messenger_bloc.dart';
import 'package:web_chat/bloc/room/room_bloc.dart';
import 'package:web_chat/screens/components/message_item.dart';

import '../../models/message_model.dart';
import '../../theme/my_theme.dart';

class ChatRoomWidget extends StatelessWidget {
  const ChatRoomWidget({super.key, this.showBackButton});

  final bool? showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state is RoomInitialState) {
          return const SizedBox();
        }
        else if (state is RoomLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        else if (state is RoomLoadingCompleteState) {
          return RoomContentWidget(messages: state.messages);
        }
        else if (state is RoomLoadingErrorState) {
          return Center(
            child: Text(state.message ?? 'Неизвестная ошибка'),
          );
        }
        return const Center(
          child: Text('Bad State'),
        );
      },
    );
  }
}

class RoomContentWidget extends StatefulWidget {
  const RoomContentWidget({super.key, required this.messages});

  final List<MessageModel> messages;

  @override
  State<RoomContentWidget> createState() => _RoomContentWidgetState();
}

class _RoomContentWidgetState extends State<RoomContentWidget> {
  final TextEditingController _messageTextController = TextEditingController();

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chat = context.read<MessengerBloc>().getCurrentChat()!;
    bool switcherValue = true;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/chat_bg.png', fit: BoxFit.cover),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: MyTheme.of(context).backgroundColor.withOpacity(.8)
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  // ? Карточка юзера
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyTheme.of(context).frontColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: chat.interlocutor.avatarUrl != null 
                            ? CachedNetworkImage(imageUrl: chat.interlocutor.avatarUrl!, fit: BoxFit.cover)
                            : Image.asset('assets/images/noavatar.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.interlocutor.name ?? chat.interlocutor.nickname,
                              style: TextStyle(
                                color: MyTheme.of(context).textColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              'Licence: 10059',
                              style: TextStyle(
                                color: MyTheme.of(context).textColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ? Actions
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch.adaptive(
                            value: switcherValue, 
                            onChanged: (newValue) {
                              setState(() {
                                switcherValue = newValue;
                              });
                            }
                          ),
                          Text(
                            switcherValue ? 'Открыт' : 'Закрыт',
                            style: TextStyle(
                              color: switcherValue ? Colors.green : Colors.red
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage('assets/images/noavatar.png'),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyTheme.of(context).frontColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(Icons.more_vert_rounded, color: MyTheme.of(context).iconColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: widget.messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return MessageItem(message: widget.messages[index]);
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 55,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: MyTheme.of(context).frontColor
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline_sharp, color: MyTheme.of(context).iconColor)
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение',
                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        filled: true,
                        fillColor: MyTheme.of(context).backgroundColor,
                        suffixIcon: const Icon(Icons.emoji_emotions_outlined),
                        suffixIconColor: MyTheme.of(context).iconColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<RoomBloc>().add(AddNewMessage(_messageTextController.text, chat.id!));
                      _messageTextController.text = '';
                    },
                    icon: Icon(Icons.send, color: MyTheme.of(context).iconColor)
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}