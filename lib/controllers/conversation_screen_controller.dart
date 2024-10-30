import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

final conversationScreenControllerProvider = NotifierProvider<ConversationScreenController, ConversationScreenState>(() {
  return ConversationScreenController();
});

class ConversationScreenController extends Notifier<ConversationScreenState> {
  late StreamSubscription _messagesSubscription;

  @override
  ConversationScreenState build() {
    ref.onDispose(() {
      _messagesSubscription.cancel();
    });
    return ConversationScreenState.initial();
  }

  void initMessagesStream({required String conversationId}) {
    _messagesSubscription = getIt<DatabaseService>().getMessages(conversationId: conversationId).listen(
      (messages) {
        state = state.copyWith(messages: AsyncData(messages));
      },
      onError: (error, stackTrace) {
        state = state.copyWith(messages: AsyncError(error, stackTrace));
      },
    );
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

        // create the message
        final Message message = Message(
          messageId: const Uuid().v4(),
          senderId: currentUser.uid,
          type: MessageType.image,
          content: downloadUrl,
          read: false,
          timestamp: DateTime.now(),
        );

        // conversation where the message will be sent
        final Conversation conversation = Conversation(
          documentId: HelperFunctions.generateConversationDocumentId(uid1: currentUser.uid, uid2: otherUser.uid),
          lastMessage: message,
          participantsUid: [currentUser.uid, otherUser.uid],
          participants: [currentUser, otherUser],
        );

        await getIt<DatabaseService>().sendMessage(conversation: conversation, message: message);
      }
    } on PlatformException catch (e) {
      HelperFunctions.showErrorSnackBar(message: 'Failed to Pick image: $e');
    } catch (e) {
      debugPrint(e.toString());
      HelperFunctions.showErrorSnackBar(message: 'Unkown error. Please try again later');
    }
  }
}
