import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/message_type.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/conversation.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/user_profile_picture.dart';

class ConversationTile extends ConsumerWidget {
  final Conversation conversation;
  const ConversationTile({super.key, required this.conversation});

  static Widget loading(BuildContext context) {
    return Row(
      children: [
        shimmerWidget(context: context, shape: BoxShape.circle, width: context.screenWidth * .14, height: context.screenHeight * .1),
        addHorizontalSpace(context.screenWidth * .03),
        shimmerWidget(context: context, width: context.screenWidth * .3, height: 16)
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(todoUserProvider).value!;
    final otherUser = conversation.participants.singleWhere((user) => user.uid != currentUser.uid);
    return GestureDetector(
      onTap: () {
        getIt<NavigationService>().routeTo(
          '/conversation',
          arguments: otherUser,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.screenHeight * .02),
        child: Row(
          children: [
            // profile picture
            UserProfilePicture(user: otherUser),
            addHorizontalSpace(context.screenWidth * .03),

            Expanded(
              child: Column(
                children: [
                  // full name and date of last message
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          otherUser.fullName,
                          style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          conversation.lastMessage.timestamp.getFormattedConversationTime(),
                          style: context.textTheme.labelSmall,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(context.screenHeight * .005),

                  // last message and seen indicator or unread message indicator
                  Row(
                    children: [
                      if (conversation.lastMessage.type == MessageType.text)
                        Expanded(
                          child: Text(
                            conversation.lastMessage.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelSmall,
                          ),
                        ),
                      if (conversation.lastMessage.type == MessageType.image)
                        Expanded(
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.image,
                                size: context.screenWidth * .04,
                              ),
                              addHorizontalSpace(context.screenWidth * .02),
                              Text(
                                "Image",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      addHorizontalSpace(context.screenWidth * .03),
                      if (conversation.lastMessage.senderId == currentUser.uid)
                        conversation.lastMessage.read
                            ? FaIcon(
                                FontAwesomeIcons.checkDouble,
                                size: context.screenWidth * .04,
                                color: context.colorScheme.secondary,
                              )
                            : FaIcon(
                                FontAwesomeIcons.check,
                                size: context.screenWidth * .04,
                              ),
                      if (conversation.lastMessage.senderId != currentUser.uid && !conversation.lastMessage.read)
                        FaIcon(
                          FontAwesomeIcons.solidCircle,
                          size: context.screenWidth * .04,
                          color: context.colorScheme.secondary,
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
