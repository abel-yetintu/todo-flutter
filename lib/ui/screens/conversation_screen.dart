import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todo/controllers/conversation_screen_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/message_type.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/message.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/audio_message_card.dart';
import 'package:todo/ui/widgets/group_header_card.dart';
import 'package:todo/ui/widgets/image_message_card.dart';
import 'package:todo/ui/widgets/message_card.dart';
import 'package:todo/ui/widgets/user_profile_picture.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final TodoUser otherUser;
  const ConversationScreen({super.key, required this.otherUser});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late TextEditingController _messageTextEditingController;
  late RecorderController _audioRecorder;

  @override
  void initState() {
    super.initState();
    _messageTextEditingController = TextEditingController();
    _audioRecorder = RecorderController();
    ref.read(conversationScreenControllerProvider.notifier).initMessagesStream(
          conversationId: HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
        );
  }

  @override
  void dispose() {
    _messageTextEditingController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.otherUser;
    final state = ref.watch(conversationScreenControllerProvider);
    final controller = ref.read(conversationScreenControllerProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              color: context.colorScheme.primaryContainer,
              height: context.screenHeight * .1,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: context.screenWidth * .02),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        getIt<NavigationService>().goBack();
                      },
                    ),
                  ),
                  UserProfilePicture(user: otherUser),
                  addHorizontalSpace(context.screenWidth * .03),
                  Expanded(
                    child: Text(
                      otherUser.fullName,
                      style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.onPrimaryContainer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),

            // messages ui
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(context.screenWidth * .05, 0, context.screenWidth * .05, 0),
                child: state.messages.when(
                  loading: () => _loadingUI(),
                  error: (error, stackTrace) => _errorUI(error.toString()),
                  data: (messages) => _messagesUI(messages),
                ),
              ),
            ),

            // For sending message
            Row(
              children: [
                Expanded(
                  child: state.isRecording
                      ? AudioWaveforms(
                          size: Size(double.infinity, context.screenHeight * .06),
                          recorderController: _audioRecorder,
                          waveStyle: WaveStyle(
                            waveColor: context.colorScheme.primary,
                            showMiddleLine: false,
                            extendWaveform: true,
                          ),
                        )
                      : TextField(
                          textCapitalization: TextCapitalization.sentences,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          controller: _messageTextEditingController,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            hintText: 'Message',
                            isDense: true,
                            suffixIcon: IconButton(
                              onPressed: state.isRecording
                                  ? null
                                  : () {
                                      if (_messageTextEditingController.text != '') {
                                        final currentUser = ref.read(todoUserProvider).value!;
                                        final conversationId = HelperFunctions.generateConversationDocumentId(uid1: currentUser.uid, uid2: otherUser.uid);
                                        controller.sendMessage(
                                          conversationId: conversationId,
                                          content: _messageTextEditingController.text,
                                          currentUser: currentUser,
                                          otherUser: otherUser,
                                          messageType: MessageType.text,
                                        );
                                        _messageTextEditingController.clear();
                                      }
                                    },
                              icon: const FaIcon(FontAwesomeIcons.paperPlane),
                            ),
                          ),
                        ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: state.isRecording
                          ? null
                          : () {
                              final currentUser = ref.read(todoUserProvider).value!;
                              final conversationId = HelperFunctions.generateConversationDocumentId(uid1: currentUser.uid, uid2: otherUser.uid);
                              controller.sendImage(
                                conversationId: conversationId,
                                currentUser: currentUser,
                                otherUser: otherUser,
                              );
                            },
                      icon: const FaIcon(FontAwesomeIcons.image),
                    ),
                    IconButton(
                      onPressed: () {
                        final currentUser = ref.read(todoUserProvider).value!;
                        final conversationId = HelperFunctions.generateConversationDocumentId(uid1: currentUser.uid, uid2: otherUser.uid);
                        controller.audioButtonPress(
                          audioRecorder: _audioRecorder,
                          conversationId: conversationId,
                          currentUser: currentUser,
                          otherUser: otherUser,
                        );
                      },
                      icon: state.isRecording ? const FaIcon(FontAwesomeIcons.stop) : const FaIcon(FontAwesomeIcons.microphone),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingUI() {
    return Expanded(
      child: Center(
        child: SpinKitThreeBounce(
          color: context.colorScheme.tertiary,
        ),
      ),
    );
  }

  Widget _errorUI(String error) {
    return Expanded(
      child: Center(
        child: Text(error),
      ),
    );
  }

  Widget _messagesUI(List<Message> messages) {
    if (messages.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('Start a conversation with ${widget.otherUser.fullName}'),
        ),
      );
    }
    return Expanded(
      child: GroupedListView<Message, DateTime>(
        physics: const BouncingScrollPhysics(),
        elements: messages,
        reverse: true,
        order: GroupedListOrder.DESC,
        groupBy: (message) => DateTime(
          message.timestamp.year,
          message.timestamp.month,
          message.timestamp.day,
        ),
        groupHeaderBuilder: (message) {
          return GroupHeaderCard(message: message);
        },
        itemBuilder: (context, message) {
          switch (message.type) {
            case MessageType.text:
              return MessageCard(
                conversationId: HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
                message: message,
                currentUserUid: ref.read(todoUserProvider).value!.uid,
              );
            case MessageType.image:
              return ImageMessageCard(
                conversationId: HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
                message: message,
                currentUserUid: ref.read(todoUserProvider).value!.uid,
              );
            case MessageType.audio:
              return AudioMessageCard(
                conversationId: HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
                message: message,
                currentUserUid: ref.read(todoUserProvider).value!.uid,
              );
          }
        },
        itemComparator: (message1, message2) {
          return message1.timestamp.compareTo(message2.timestamp);
        },
      ),
    );
  }
}
