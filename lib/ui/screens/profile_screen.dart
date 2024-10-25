import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/controllers/profile_screen_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/providers/theme_notifier.dart';
import 'package:todo/ui/widgets/delete_account_bottom_sheet.dart';
import 'package:todo/ui/widgets/profile_tile.dart';
import 'package:todo/ui/widgets/update_profile_picture_bottom_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(todoUserProvider).value!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .05, vertical: context.screenHeight * .02),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            addVerticalSpace(context.screenHeight * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () => _showUpdateProfilePictureBottomSheet(context),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: context.screenWidth * .15,
                            backgroundColor: context.colorScheme.primary,
                            backgroundImage: currentUser.profilePicture.isNotEmpty ? NetworkImage(currentUser.profilePicture) : null,
                            child: currentUser.profilePicture.isEmpty
                                ? FaIcon(
                                    FontAwesomeIcons.user,
                                    color: context.colorScheme.onPrimary,
                                    size: context.screenWidth * .1,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: context.screenWidth * .05,
                              child: FaIcon(
                                FontAwesomeIcons.pencil,
                                size: context.screenWidth * .05,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    addVerticalSpace(context.screenHeight * .01),
                    Text(
                      "@${currentUser.userName}",
                      style: context.textTheme.bodyLarge,
                    )
                  ],
                ),
              ],
            ),
            addVerticalSpace(context.screenHeight * .03),
            ProfileTile(
              icon: FontAwesomeIcons.idBadge,
              title: currentUser.fullName,
            ),
            addVerticalSpace(context.screenHeight * .02),
            ProfileTile(
              icon: FontAwesomeIcons.envelope,
              title: currentUser.email,
            ),
            addVerticalSpace(context.screenHeight * .03),
            Text(
              'Settings',
              style: context.textTheme.bodyLarge,
            ),
            addVerticalSpace(context.screenHeight * .03),
            Container(
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
                        FontAwesomeIcons.moon,
                        size: context.screenWidth * .06,
                      ),
                    ),
                  ),
                  addHorizontalSpace(context.screenWidth * .03),
                  const Expanded(
                    child: Text(
                      'Dark Mode',
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Transform.scale(
                      scale: .7,
                      child: Switch(
                        value: ref.watch(themeNotifierProvider) == ThemeMode.dark,
                        onChanged: (value) {
                          ref.read(themeNotifierProvider.notifier).toggleTheme();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(context.screenHeight * .03),
            GestureDetector(
              onTap: () {
                ref.read(profileScreenControllerProvider.notifier).signOut();
              },
              child: const ProfileTile(
                icon: FontAwesomeIcons.arrowRightFromBracket,
                title: 'Sign Out',
              ),
            ),
            addVerticalSpace(context.screenHeight * .02),
            GestureDetector(
              onTap: () async {
                _showDeleteAccountBottomSheet(context);
              },
              child: const ProfileTile(
                icon: FontAwesomeIcons.trash,
                title: 'Delete Account',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DeleteAccountBottomSheet();
      },
    );
  }

  void _showUpdateProfilePictureBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return const UpdateProfilePictureBottomSheet();
      },
    );
  }
}
