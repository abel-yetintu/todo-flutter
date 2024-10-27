import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/search_user_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/collaborator_user_tile.dart';

class AddCollaboratorScreen extends ConsumerWidget {
  final Todo todo;
  const AddCollaboratorScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.screenWidth * .05, context.screenHeight * .02, context.screenWidth * .05, 0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      getIt<NavigationService>().goBack();
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                    ),
                  ),
                  addHorizontalSpace(context.screenWidth * .05),
                  Text(
                    'Add a collaborator',
                    style: context.textTheme.bodyLarge,
                  )
                ],
              ),
              addVerticalSpace(context.screenHeight * .02),

              // search textfield
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(hintText: 'User Name'),
                onChanged: (value) {
                  ref.read(searchUserControllerProvider.notifier).searchUser(query: value);
                },
              ),
              addVerticalSpace(context.screenHeight * .02),

              // list view of result
              ref.watch(searchUserControllerProvider).when(
                    loading: () => _loadingUI(context),
                    error: (error, stackTrace) => _errorUI(context, error),
                    data: (todoUsers) {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: todoUsers.length,
                          itemBuilder: (context, index) {
                            return CollaboratorUserTile(todoUser: todoUsers[index], todo: todo);
                          },
                        ),
                      );
                    },
                  )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingUI(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return CollaboratorUserTile.loading(context);
        },
      ),
    );
  }

  Widget _errorUI(BuildContext context, Object error) {
    return Text(error.toString());
  }
}
