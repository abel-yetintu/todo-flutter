import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const ProfileTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .03, vertical: context.screenHeight * .01),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary.withOpacity(.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.screenWidth * .07,
            child: Align(
              child: FaIcon(
                icon,
                size: context.screenWidth * .06,
              ),
            ),
          ),
          addHorizontalSpace(context.screenWidth * .03),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
