import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/audio_message_card_controller.dart';
import 'package:todo/controllers/message_card_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/message.dart';

class AudioMessageCard extends ConsumerWidget {
  final Message message;
  final String currentUserUid;
  final String conversationId;
  const AudioMessageCard({super.key, required this.message, required this.currentUserUid, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCurrentUser = currentUserUid == message.senderId;
    Color background = isCurrentUser ? context.colorScheme.primaryContainer : context.colorScheme.secondaryContainer;
    Color onBackground = isCurrentUser ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSecondaryContainer;
    Alignment alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    if (message.senderId != currentUserUid && message.read == false) {
      ref.read(messageCardControllerProvider.notifier).markMessageRead(message: message, conversationId: conversationId);
    }

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: context.screenWidth * 0.8),
        margin: EdgeInsets.only(bottom: context.screenHeight * .01),
        padding: EdgeInsets.symmetric(vertical: context.screenHeight * .01, horizontal: context.screenWidth * .02),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'audio',
                  style: TextStyle(color: onBackground),
                ),
                addHorizontalSpace(context.screenWidth * .02),
                GestureDetector(
                  onTap: () {
                    ref.read(audioMessageCardControllerProvider(message.messageId).notifier).onPlayOrPause(url: message.content);
                  },
                  child: FaIcon(
                    ref.watch(audioMessageCardControllerProvider(message.messageId)) ? FontAwesomeIcons.stop : FontAwesomeIcons.play,
                    size: context.screenWidth * .07,
                    color: onBackground,
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.timestamp.getTime(),
                  style: context.textTheme.labelSmall!.copyWith(color: onBackground, fontWeight: FontWeight.w300),
                ),
                if (message.senderId == currentUserUid) addHorizontalSpace(context.screenWidth * .02),
                if (message.senderId == currentUserUid)
                  message.read
                      ? FaIcon(FontAwesomeIcons.checkDouble, size: context.screenWidth * .04, color: context.colorScheme.onPrimaryContainer)
                      : FaIcon(FontAwesomeIcons.check, size: context.screenWidth * .04, color: context.colorScheme.onPrimaryContainer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
