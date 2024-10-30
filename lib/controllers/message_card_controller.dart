import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/data/models/message.dart';
import 'package:todo/services/database_service.dart';

final messageCardControllerProvider = NotifierProvider<MessageCardController, void>(() => MessageCardController());

class MessageCardController extends Notifier<void> {
  @override
  void build() {}

  Future<void> markMessageRead({required Message message, required String conversationId}) async {
    try {
      getIt<DatabaseService>().markMessageRead(conversationId: conversationId, message: message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
