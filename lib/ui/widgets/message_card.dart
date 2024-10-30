import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/message_card_controller.dart';
import 'package:todo/core/enums/message_type.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/message.dart';

class MessageCard extends ConsumerWidget {
  final Message message;
  final String currentUserUid;
  final String conversationId;
  const MessageCard({super.key, required this.message, required this.currentUserUid, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCurrentUser = currentUserUid == message.senderId;
    Color background = isCurrentUser ? context.colorScheme.primaryContainer : context.colorScheme.secondaryContainer;
    Color onBackground = isCurrentUser ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSecondaryContainer;
    Alignment alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    if (message.senderId != currentUserUid && message.read == false) {
      ref.read(messageCardControllerProvider.notifier).markMessageRead(message: message, conversationId: conversationId);
    }

    if (message.type == MessageType.image) {
      return Align(
        alignment: alignment,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: context.screenHeight * .01),
              height: context.screenHeight * .3,
              width: context.screenWidth * .7,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.content,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: context.screenHeight * .4,
                      width: context.screenWidth * .5,
                      color: context.colorScheme.primary.withOpacity(.4),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .02),
                padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .005),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.timestamp.getTime(),
                      style: context.textTheme.labelSmall!.copyWith(color: context.colorScheme.onSecondaryContainer, fontWeight: FontWeight.w300),
                    ),
                    if (message.senderId == currentUserUid) addHorizontalSpace(context.screenWidth * .02),
                    if (message.senderId == currentUserUid)
                      message.read
                          ? FaIcon(FontAwesomeIcons.checkDouble, size: context.screenWidth * .04, color: context.colorScheme.onSecondaryContainer)
                          : FaIcon(FontAwesomeIcons.check, size: context.screenWidth * .04, color: context.colorScheme.onSecondaryContainer),
                  ],
                ),
              ),
            )
          ],
        ),
      );
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
            Text(
              message.content,
              textAlign: TextAlign.start,
              style: context.textTheme.bodyMedium!.copyWith(color: onBackground),
            ),
            addVerticalSpace(context.screenHeight * .005),
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
