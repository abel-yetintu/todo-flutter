import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/enums/message_type.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/data/models/conversation.dart';
import 'package:todo/data/models/conversation_screen_state.dart';
import 'package:todo/data/models/message.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/services/image_picker_service.dart';
import 'package:todo/services/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

final conversationScreenControllerProvider = NotifierProvider.family<ConversationScreenController, ConversationScreenState, String>(() {
  return ConversationScreenController();
});

class ConversationScreenController extends FamilyNotifier<ConversationScreenState, String> {
  late StreamSubscription _messagesSubscription;

  @override
  ConversationScreenState build(arg) {
    ref.onDispose(() {
      _messagesSubscription.cancel();
    });
    return ConversationScreenState.initial();
  }

  void initMessagesStream({required String conversationId}) {
    _messagesSubscription = getIt<DatabaseService>().getMessages(conversationId: conversationId).listen(
      (messages) {
        state = state.copyWith(messages: AsyncData(messages));
        _updateFilteredMessages(messages);
      },
      onError: (error, stackTrace) {
        state = state.copyWith(messages: AsyncError(error, stackTrace));
      },
    );
  }

  void showSearchBar(bool value) {
    state = state.copyWith(isSearching: value);
  }

  void setSearchQuery(String searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
    _updateFilteredMessages(state.messages.value ?? []);
  }

  void _updateFilteredMessages(List<Message> messages) {
    final filteredMessages = state.searchQuery.isNotEmpty
        ? messages.where(
            (message) {
              return message.content.toLowerCase().contains(state.searchQuery.toLowerCase()) && message.type == MessageType.text;
            },
          ).toList()
        : messages;

    state = state.copyWith(filteredMessages: filteredMessages);
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    required TodoUser currentUser,
    required TodoUser otherUser,
    required MessageType messageType,
  }) async {
    try {
      final Message message = Message(
        messageId: const Uuid().v4(),
        senderId: currentUser.uid,
        type: messageType,
        content: content,
        read: false,
        timestamp: DateTime.now(),
      );

      final Conversation conversation = Conversation(
        documentId: HelperFunctions.generateConversationDocumentId(uid1: currentUser.uid, uid2: otherUser.uid),
        lastMessage: message,
        participantsUid: [currentUser.uid, otherUser.uid],
        participants: [currentUser, otherUser],
      );

      await getIt<DatabaseService>().sendMessage(conversation: conversation, message: message);
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
    }
  }

  Future<void> sendImage({
    required String conversationId,
    required TodoUser currentUser,
    required TodoUser otherUser,
  }) async {
    try {
      // pick image from gallery
      var file = await getIt<ImagePickerService>().pickImage(imageSource: ImageSource.gallery);

      if (file != null) {
        // save image in firebase storage
        final downloadUrl = await getIt<StorageService>().saveImage(file: file);

        // send the message to conversation document
        sendMessage(
          conversationId: conversationId,
          content: downloadUrl,
          currentUser: currentUser,
          otherUser: otherUser,
          messageType: MessageType.image,
        );
      }
    } on PlatformException catch (e) {
      HelperFunctions.showErrorSnackBar(message: 'Failed to Pick image: $e');
    } catch (e) {
      debugPrint(e.toString());
      HelperFunctions.showErrorSnackBar(message: 'Unkown error. Please try again later');
    }
  }

  Future<void> audioButtonPress({
    required RecorderController audioRecorder,
    required String conversationId,
    required TodoUser currentUser,
    required TodoUser otherUser,
  }) async {
    try {
      if (!state.isRecording) {
        if (await audioRecorder.checkPermission()) {
          state = state.copyWith(isRecording: true);

          // get temp directory
          final documentsDir = await getTemporaryDirectory();
          final filePath = p.join(documentsDir.path, '${DateTime.now().millisecondsSinceEpoch.toString()}.wav');

          // start recording
          await audioRecorder.record(path: filePath, androidEncoder: AndroidEncoder.aac, iosEncoder: IosEncoder.kAudioFormatMPEG4AAC);
        }
      } else {
        state = state.copyWith(isRecording: false);

        // stop the recording and retrive the audio file path
        String? filePath = await audioRecorder.stop();

        if (filePath != null) {
          File file = File(filePath);

          // upload audio to firebase storage and retrive the download url
          final downloadUrl = await getIt<StorageService>().uploadAudio(file: file);

          // send the message to conversation document
          sendMessage(
            conversationId: conversationId,
            currentUser: currentUser,
            otherUser: otherUser,
            content: downloadUrl,
            messageType: MessageType.audio,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(isRecording: false);
      debugPrint(e.toString());
      HelperFunctions.showErrorSnackBar(message: e.toString());
    }
  }
}
