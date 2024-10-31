import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/chat_screen_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/ui/widgets/conversation_tile.dart';
import 'package:todo/ui/widgets/search_user_tile.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _searchTextEditingController;

  @override
  void initState() {
    super.initState();
    _searchTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // text field to search for users
        TextField(
          controller: _searchTextEditingController,
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: GestureDetector(
              onTap: () {
                _searchTextEditingController.clear();
                ref.read(chatScreenControllerProvider.notifier).setQueryTerm(query: '');
              },
              child: ref.watch(chatScreenControllerProvider).query.isNotEmpty ? const Icon(FontAwesomeIcons.x) : const Icon(FontAwesomeIcons.magnifyingGlass),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: context.screenWidth * .07, vertical: context.screenHeight * .02),
            enabledBorder: InputBorder.none,
            focusedBorder: const UnderlineInputBorder(),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            ref.read(chatScreenControllerProvider.notifier).setQueryTerm(query: value);
          },
        ),
        addVerticalSpace(context.screenHeight * .01),

        // show chats or user search result dynamically
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.screenWidth * .05, context.screenHeight * .02, context.screenWidth * .05, 0),
            child: Column(
              children: [
                if (ref.watch(chatScreenControllerProvider).showChats) _chatUI(context),
                if (!ref.watch(chatScreenControllerProvider).showChats) _searchResultUI(context)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chatUI(BuildContext context) {
    return ref.watch(conversationsProvider).when(
          loading: () {
            return Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ConversationTile.loading(context);
                },
              ),
            );
          },
          error: (error, stackTrace) => Expanded(
            child: Center(
              child: Text(error.toString()),
            ),
          ),
          data: (conversations) {
            if (conversations.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('Message a friend to get started!'),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return ConversationTile(conversation: conversations[index]);
                },
              ),
            );
          },
        );
  }

  Widget _searchResultUI(BuildContext context) {
    return ref.watch(chatScreenControllerProvider).searchResult.when(
      loading: () {
        return Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              return SearchUserTile.loading(context);
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return Expanded(
          child: Center(
            child: Text(error.toString()),
          ),
        );
      },
      data: (todoUsers) {
        return Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: todoUsers.length,
            itemBuilder: (context, index) {
              return SearchUserTile(todoUser: todoUsers[index]);
            },
          ),
        );
      },
    );
  }
}
