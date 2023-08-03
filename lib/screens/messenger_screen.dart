import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_chat/bloc/messenger/messenger_bloc.dart';

import '../components/widgets/responsive_layout.dart';
import '../theme/my_theme.dart';
import 'components/chats_room_widget.dart';
import 'components/chats_widget.dart';
import 'components/mobile_header.dart';

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).backgroundColor,
      body: const ResponsiveLayout(
        mobile: Mobile(),
        tablet: Desktop(),
        dekstop: Desktop(),
      ),
    );
  }
}

class Mobile extends StatelessWidget {
  const Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessengerBloc, MessengerState>(
      builder: (context, state) {
        if (state is LoadingChatsState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } 
        else if (state is LoadChatsCompleteState) {
          if (state.selectedChatId != null) {
            return const ChatRoomWidget(showBackButton: true);
          }

          return const Column(
            children: [
              MobileHeader(),
              Expanded(
                child: ChatsWidget(),
              ),
            ],
          );
        }
        else if (state is LoadChatsErrorState) {
          return Center(
            child: Text(
              state.message ?? 'Неизвестная ошибка'
            ),
          );
        }

        return const Center(
          child: Text('Bad state'),
        );
      },
    );
  }
}

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const DesktopHeader(),
        // Padding(
        //   padding: const EdgeInsets.only(top: 24, left: 24),
        //   child: Text(
        //     "All Messages",
        //     style: Theme.of(context).textTheme.titleLarge,
        //   ),
        // ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ChatsWidget(),
                ),
                VerticalDivider(),
                Expanded(
                  flex: 7,
                  child: ChatRoomWidget(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
