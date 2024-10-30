import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/data/models/todo_user.dart';

class UserProfilePicture extends StatelessWidget {
  final TodoUser user;
  const UserProfilePicture({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: context.screenWidth * .07,
      backgroundColor: context.colorScheme.primary,
      backgroundImage: user.profilePicture.isNotEmpty ? NetworkImage(user.profilePicture) : null,
      child: user.profilePicture.isEmpty
          ? FaIcon(
              FontAwesomeIcons.user,
              color: context.colorScheme.onPrimary,
              size: context.screenWidth * .05,
            )
          : null,
    );
  }
}
