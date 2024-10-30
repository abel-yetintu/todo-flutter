import 'package:flutter/material.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/data/models/message.dart';

class GroupHeaderCard extends StatelessWidget {
  final Message message;
  const GroupHeaderCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.only(bottom: context.screenHeight * .01),
        color: context.colorScheme.tertiary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .02, vertical: context.screenHeight * .01),
          child: Text(
            message.timestamp.getFormattedDate(),
            style: context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.onTertiary),
          ),
        ),
      ),
    );
  }
}
