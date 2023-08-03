
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../models/current_user.dart';
import '../../models/message_model.dart';
import '../../theme/my_theme.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final double _userProfileAvatarSize = 55.0;
  late DateFormat messageDateFormat;
  bool _isShowSticker = false;
  late bool _isOwnerMessage;
  late MessageModel _message;
  bool isVideo = false;
  int imageIndexPosition = 0;

  DateFormat getDateFormat(DateTime dateTimeToCompare) {
    if (DateTime.now().year == dateTimeToCompare.year) {
      if (DateTime.now().month == dateTimeToCompare.month) {
        if (DateTime.now().day == dateTimeToCompare.day) {
          // Only time
          return DateFormat("HH:mm"); 
        }
        else {
          // Day & time
          return DateFormat("dd MMM HH:mm");
        }
      }
      else {
        // Day, month and time
        return DateFormat("dd MMM HH:mm");
      }
    }
    else {
      // Full date
      return DateFormat("dd MMM yyyy HH:mm");
    }
  }

  Future _deleteMessage() async {
    OkCancelResult response = await showOkCancelAlertDialog(
      context: context,
      isDestructiveAction: true,
      title: 'Удалить',
      message: 'Это действие нельзя отменить.\nСообщение будет удалено у всех участников чата.\nПродолжить?'
    );
    if (response.index == 1) return;
    if (_message.id == null) return;
    // TODO: сделать удаление сообщения
    Navigator.pop(context);
  }

  Future<bool> _onBackPress() {
    if (_isShowSticker) {
      setState(() {
        _isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  List<Widget> get _contextMenuActions => [
    CupertinoContextMenuAction(
      onPressed: () async {
        await _deleteMessage();
      },
      isDestructiveAction: true,
      trailingIcon: CupertinoIcons.delete,
      child: const Text('Удалить у всех'),
    ),
    CupertinoContextMenuAction(
      onPressed: () async {
        // TODO: Сделать жалобу на сообщение
      },
      isDestructiveAction: true,
      trailingIcon: Icons.report_rounded,
      child: const Text('Пожаловаться'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    var theme = MyTheme.of(context);

    _message = widget.message;
    DateTime dateTimeToCompareMessage = _message.createTime;
    messageDateFormat = getDateFormat(dateTimeToCompareMessage);

    Size size = MediaQuery.of(context).size;
    _isOwnerMessage = _message.author.id == CurrentUser.currentUser.id;

    return Row(
      mainAxisAlignment: _isOwnerMessage
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (!_isOwnerMessage) GestureDetector(
          onTap: () {
            // TODO: открывать профиль юзера
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: CircleAvatar(
              backgroundColor: theme.backgroundColor,
              radius: 15.0,
              child: ClipOval(
                child: (_message.author.avatarUrl == null || _message.author.avatarUrl == '')
                ? Image(
                  height: _userProfileAvatarSize,
                  width: _userProfileAvatarSize,
                  image: const AssetImage('assets/images/noavatar.png'),
                  fit: BoxFit.cover,
                )
                : CachedNetworkImage( 
                  fadeInDuration: Duration.zero,
                  height: _userProfileAvatarSize,
                  width: _userProfileAvatarSize,
                  imageUrl: _message.author.avatarUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) => const Icon(Icons.error)
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: _isOwnerMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ? Ответ на сообщение
            if (_message.replyMessage != null) Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                // color: Constant.clusterAccentColor.withOpacity(.3),
                borderRadius: BorderRadius.circular(9.0),
                color: theme.brandColor.withOpacity(.1),
                // borderRadius: BorderRadius.only(
                //   topLeft: const Radius.circular(9.0),
                //   topRight: const Radius.circular(9.0),
                //   bottomLeft: !_isOwnerMessage ? const Radius.circular(3.0) : const Radius.circular(9.0),
                //   bottomRight: _isOwnerMessage ? const Radius.circular(3.0) : const Radius.circular(9.0),
                // )
              ),
              //Ответ на сообщение
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.brandColor
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    
                    // ? История иконка (пересланное)
                    if (_message.replyMessage != null && (_message.replyMessage?.contentType == 'story-image' || _message.replyMessage?.contentType == 'story-video')) Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 60,
                      width: 37,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: theme.brandColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Icon(Icons.subscriptions_rounded, color: theme.brandColor, size: 25,),
                    ),

                    // ? Фото/видео иконка (пересланное)
                    if (false) Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 48,
                      width: 45,
                      decoration: BoxDecoration(
                        color: theme.brandColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),

                    // ? Файл иконка (пересланное)
                    if (false) Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 40,
                      width: 37,
                      decoration: BoxDecoration(
                        color: theme.brandColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Icon(Icons.file_present_rounded, color: theme.brandColor, size: 25,),
                    ),

                    // ? Голосовое сообщение иконка (пересланное)
                    if (_message.replyMessage != null && _message.replyMessage?.contentType == 'voice') Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 40,
                      width: 37,
                      decoration: BoxDecoration(
                        color: theme.brandColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Icon(CupertinoIcons.speaker_1_fill, color: theme.brandColor, size: 25,),
                    ),

                    // ? Контент пересланного сообщения
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.6
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Text(
                            _message.replyMessage != null 
                            ? (_message.replyMessage?.author.name != null && _message.replyMessage?.author.name != '') 
                              ? _message.replyMessage!.author.name! 
                              : _message.replyMessage!.author.nickname
                            : "Unknown",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.brandColor,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),

                          // ? Текст           
                          if (_message.replyMessage != null && _message.replyMessage?.contentType == 'text') Text(
                            _message.replyMessage!.content,
                            maxLines: 8,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textColor.withOpacity(.4),
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          // ? История
                          if (_message.replyMessage != null && _message.replyMessage?.contentType == 'story-image' || _message.replyMessage?.contentType == 'story-video') Text(
                            'История',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textColor.withOpacity(.4),
                              fontWeight: FontWeight.normal,
                            ),
                          ), 

                          // ? Фото
                          if(false) const Text(
                            'Фото',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          // ? Видео
                          if(false) const Text(
                            'Видео',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          // ? Файл 
                          if(false) const Text(
                            'file_name.rar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          // ? Голсовое
                          if (_message.replyMessage != null && _message.replyMessage?.contentType == 'voice') Text(
                            'Голосовое сообщение',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textColor.withOpacity(.4),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ? Само сообщение
            if (_message.contentType == 'text' || _message.contentType == 'service-message' || _message.contentType == null) CupertinoContextMenu(
              actions: _contextMenuActions,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    constraints: BoxConstraints(
                      minWidth: 20.0,
                      minHeight: 40.0,
                      maxWidth: size.width * 0.7
                    ),
                    decoration: BoxDecoration(
                      // color: _message.isRead! ? Constant.frontColor : const Color(0xFF0049B7),
                      gradient: LinearGradient(
                        colors: !_isOwnerMessage 
                          ? [theme.frontColor, theme.frontColor]
                          : _message.isRead! ? [theme.frontColor, theme.frontColor] : [const Color.fromARGB(255, 175, 225, 243), const Color.fromARGB(255, 166, 216, 233)],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: const [0.0, 1.0],
                        tileMode: TileMode.clamp
                      ),
                      borderRadius: BorderRadius.only(
                        // topLeft:  !_isOwnerMessage && _message.replyMessage != null ? const Radius.circular(3.0) : const Radius.circular(18.0),
                        // topRight: _isOwnerMessage && _message.replyMessage != null ? const Radius.circular(3.0) : const Radius.circular(18.0),
                        topLeft: const Radius.circular(18.0),
                        topRight: const Radius.circular(18.0),
                        bottomLeft: !_isOwnerMessage ? const Radius.circular(9.0) : const Radius.circular(18.0),
                        bottomRight: _isOwnerMessage ? const Radius.circular(9.0) : const Radius.circular(18.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2)
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _message.content,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.longestLine,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 15,
                          color: _isOwnerMessage
                            ? _message.isRead! 
                              ? _message.contentType == 'service-message' ? theme.textColor.withOpacity(.5) : theme.textColor
                              : _message.contentType == 'service-message' ? Colors.black54 : Colors.black // не прочитанные сообщения тут
                            : _message.contentType == 'service-message' ? theme.textColor.withOpacity(.5) : theme.textColor,
                          fontStyle: _message.contentType == 'service-message' ? FontStyle.italic : null
                        ),
                      ),
                    ),
                  ),
                  if (widget.message.status == MessageStatus.sent) Positioned(
                    right: 10,
                    bottom: 5,
                    child: Icon(
                      Icons.watch_later_outlined,
                      color: theme.iconColor,
                      size: 12,
                    )
                  ),
                  if (widget.message.status == MessageStatus.errorSent) const Positioned(
                    right: 10,
                    bottom: 5,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 12,
                    )
                  )
                ],
              ),
            ),
            if (_message.contentType == 'voice') CupertinoContextMenu(
              actions: _contextMenuActions,
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                      constraints: BoxConstraints(
                        minWidth: 20.0,
                        minHeight: 40.0,
                        maxWidth: size.width * 0.7,
                        maxHeight: size.width * 0.5
                      ),
                      decoration: BoxDecoration(
                        // color: _message.isRead! ? Constant.frontColor : const Color(0xFF0049B7),
                        gradient: LinearGradient(
                          colors: !_isOwnerMessage 
                            ? [theme.frontColor, theme.frontColor]
                            : _message.isRead! ? [theme.frontColor, theme.frontColor] : [const Color.fromARGB(255, 175, 225, 243), const Color.fromARGB(255, 166, 216, 233)],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp
                        ),
                        borderRadius: BorderRadius.only(
                          // topLeft:  !_isOwnerMessage && _message.replyMessage != null ? const Radius.circular(3.0) : const Radius.circular(18.0),
                          // topRight: _isOwnerMessage && _message.replyMessage != null ? const Radius.circular(3.0) : const Radius.circular(18.0),
                          topLeft: const Radius.circular(18.0),
                          topRight: const Radius.circular(18.0),
                          bottomLeft: !_isOwnerMessage ? const Radius.circular(9.0) : const Radius.circular(18.0),
                          bottomRight: _isOwnerMessage ? const Radius.circular(9.0) : const Radius.circular(18.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2)
                          )
                        ]
                      ),
                      child: Wrap(
                        children: [
                          if (_message.content.startsWith('{')) VoiceMessage(
                            me: _isOwnerMessage,
                            duration: Duration(milliseconds: json.decode(_message.content)['duration']),
                            mePlayIconColor: Colors.black,
                            contactPlayIconColor: Colors.black,
                            contactPlayIconBgColor: theme.brandColor,
                            meBgColor: _message.isRead! ? theme.frontColor.withOpacity(.4) : Colors.transparent,
                            contactBgColor: _message.isRead! ? theme.frontColor.withOpacity(.4) : Colors.transparent,
                            meFgColor: theme.brandColor,
                            contactFgColor: theme.brandColor,
                            contactCircleColor: theme.brandColor,
                            audioSrc: json.decode(_message.content)['url'],//'https://sounds-mp3.com/mp3/0012660.mp3',
                          )
                          else Text('Контент сообщения повреждён', style: TextStyle(fontSize: 15, color: theme.textColor.withOpacity(.5), fontStyle: FontStyle.italic))
                        ],
                      )
                    ),
                    if (_message.status == MessageStatus.sent) Positioned(
                      right: 10,
                      bottom: 5,
                      child: Icon(
                      Icons.watch_later_outlined,
                        color: theme.iconColor,
                        size: 12,
                      )
                    ),
                    if (_message.status == MessageStatus.errorSent) const Positioned(
                      right: 10,
                      bottom: 5,
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 12,
                      )
                    )
                  ],
                ),
              ),
            ),

            // ? Дата отправки сообщения
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              child: Text(
                messageDateFormat.format(_message.createTime.add(DateTime.now().timeZoneOffset)),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textColor.withOpacity(.2)
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}