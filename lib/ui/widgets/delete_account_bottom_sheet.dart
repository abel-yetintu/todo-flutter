import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/controllers/profile_screen_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/navigation_service.dart';

class DeleteAccountBottomSheet extends ConsumerStatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  ConsumerState<DeleteAccountBottomSheet> createState() => _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends ConsumerState<DeleteAccountBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * .05, vertical: context.screenHeight * .02),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Account',
                style: context.textTheme.headlineSmall,
              ),
              addVerticalSpace(context.screenHeight * .02),
              Text("You are about to permanently delete your account. Please enter your password to confirm", style: context.textTheme.bodySmall),
              addVerticalSpace(context.screenHeight * .02),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    addVerticalSpace(context.screenHeight * .01),
                    TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return 'Enter password';
                      },
                    ),
                    addVerticalSpace(context.screenHeight * .02),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: context.theme.filledButtonTheme.style?.copyWith(backgroundColor: WidgetStatePropertyAll(context.colorScheme.error)),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            getIt<NavigationService>().goBack();
                            ref.read(profileScreenControllerProvider.notifier).deleteAccount(password: password, todoUser: ref.read(todoUserProvider).value!);
                          }
                        },
                        child: Text(
                          'Delete Account',
                          style: TextStyle(color: context.colorScheme.onError),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
