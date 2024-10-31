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
import 'package:todo/data/models/conversation_screen_state.dart';
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
  late TextEditingController _searchTextEditingController;
  late RecorderController _audioRecorder;

  @override
  void initState() {
    super.initState();
    _messageTextEditingController = TextEditingController();
    _searchTextEditingController = TextEditingController();
    _searchTextEditingController.text = ref
        .read(conversationScreenControllerProvider(
          HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
        ))
        .searchQuery;
    _audioRecorder = RecorderController();
    ref
        .read(
          conversationScreenControllerProvider(
            HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
          ).notifier,
        )
        .initMessagesStream(
          conversationId: HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid),
        );
  }

  @override
  void dispose() {
    _messageTextEditingController.dispose();
    _searchTextEditingController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationId = HelperFunctions.generateConversationDocumentId(uid1: ref.read(todoUserProvider).value!.uid, uid2: widget.otherUser.uid);
    final otherUser = widget.otherUser;
    final state = ref.watch(conversationScreenControllerProvider(conversationId));
    final controller = ref.read(conversationScreenControllerProvider(conversationId).notifier);
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

                  // show user detail or search bar
                  if (!state.isSearching)
                    Expanded(
                      child: Row(
                        children: [
                          UserProfilePicture(user: otherUser),
                          addHorizontalSpace(context.screenWidth * .03),
                          Expanded(
                            child: Text(
                              otherUser.fullName,
                              style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.onPrimaryContainer),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state.isSearching)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: context.screenWidth * .04),
                        child: TextField(
                          controller: _searchTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            filled: true,
                            fillColor: Colors.transparent,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _searchTextEditingController.clear();
                                controller.showSearchBar(false);
                                controller.setSearchQuery('');
                              },
                              child: const Icon(FontAwesomeIcons.x),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: context.screenWidth * .07, vertical: context.screenHeight * .02),
                            enabledBorder: InputBorder.none,
                            focusedBorder: const UnderlineInputBorder(),
                          ),
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (value) {
                            controller.setSearchQuery(value);
                          },
                        ),
                      ),
                    ),
                  if (!state.isSearching)
                    Row(
                      children: [
                        addHorizontalSpace(context.screenWidth * .03),
                        Padding(
                          padding: EdgeInsets.only(right: context.screenWidth * .04),
                          child: GestureDetector(
                            onTap: () {
                              controller.showSearchBar(true);
                            },
                            child: FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: context.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        )
                      ],
                    ),
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
                  data: (_) => _messagesUI(state),
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
    return Center(
      child: SpinKitThreeBounce(
        color: context.colorScheme.tertiary,
      ),
    );
  }

  Widget _errorUI(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget _messagesUI(ConversationScreenState state) {
    if (state.messages.value!.isEmpty) {
      return Center(
        child: Text('Start a conversation with ${widget.otherUser.fullName}'),
      );
    }
    return GroupedListView<Message, DateTime>(
      physics: const BouncingScrollPhysics(),
      elements: state.filteredMessages,
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
    );
  }
}
