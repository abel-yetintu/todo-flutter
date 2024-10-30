import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/widgets/user_profile_picture.dart';

class SearchUserTile extends ConsumerWidget {
  final TodoUser todoUser;
  const SearchUserTile({super.key, required this.todoUser});

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
    return GestureDetector(
      onTap: () {
        getIt<NavigationService>().routeTo(
          '/conversation',
          arguments: todoUser,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.screenHeight * .02),
        child: Row(
          children: [
            UserProfilePicture(user: todoUser),
            addHorizontalSpace(context.screenWidth * .03),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todoUser.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '@${todoUser.userName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
