import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/controllers/update_profile_picture_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';

class UpdateProfilePictureBottomSheet extends ConsumerWidget {
  const UpdateProfilePictureBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.image),
          title: const Text('Pick an image'),
          onTap: () {
            getIt<NavigationService>().goBack();
            ref.read(updateProfilePictureControllerProvider.notifier).updateProfilePicture(
                  imageSource: ImageSource.gallery,
                  todoUser: ref.read(todoUserProvider).value!,
                );
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.camera),
          title: const Text('Take a picture'),
          onTap: () {
            getIt<NavigationService>().goBack();
            ref.read(updateProfilePictureControllerProvider.notifier).updateProfilePicture(
                  imageSource: ImageSource.camera,
                  todoUser: ref.read(todoUserProvider).value!,
                );
          },
        ),
        if (ref.read(todoUserProvider).value!.profilePicture != '')
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.trash),
            title: const Text('Remove profile picture'),
            onTap: () {
              getIt<NavigationService>().goBack();
              ref.read(updateProfilePictureControllerProvider.notifier).removeProfilePicture(todoUser: ref.read(todoUserProvider).value!);
            },
          ),
      ],
    );
  }
}
