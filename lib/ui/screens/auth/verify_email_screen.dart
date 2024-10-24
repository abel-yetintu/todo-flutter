import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/controllers/verify_email_screen_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(verifyEmailScreenControllerProvider.notifier).sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.screenWidth * 0.05,
            context.screenHeight * 0.025,
            context.screenWidth * 0.05,
            0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Email',
                style: context.textTheme.headlineSmall,
              ),
              addVerticalSpace(context.screenHeight * 0.01),
              Text(
                "A verification link has been sent to your email adress.",
                style: context.textTheme.bodySmall,
                maxLines: 2,
              ),
              addVerticalSpace(context.screenHeight * 0.05),
              _buildResendButton(),
              addVerticalSpace(context.screenHeight * 0.01),
              _buildCancelButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(verifyEmailScreenControllerProvider);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: state
                ? () {
                    ref.read(verifyEmailScreenControllerProvider.notifier).sendEmailVerification();
                  }
                : null,
            child: const Text("Resend"),
          ),
        );
      },
    );
  }

  Widget _buildCancelButton() {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: context.theme.filledButtonTheme.style?.copyWith(backgroundColor: WidgetStatePropertyAll(context.colorScheme.error)),
            onPressed: () {
              ref.read(verifyEmailScreenControllerProvider.notifier).cancel();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: context.colorScheme.onError),
            ),
          ),
        );
      },
    );
  }
}
