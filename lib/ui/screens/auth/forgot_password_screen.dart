import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/controllers/reset_password_button_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/core/utils/helper_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    super.dispose();
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
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              shrinkWrap: true,
              children: [
                Text(
                  'Reset Password',
                  style: context.textTheme.headlineSmall,
                ),
                addVerticalSpace(context.screenHeight * 0.01),
                Text(
                  "Enter you email address and we will send you a password reset link",
                  style: context.textTheme.bodySmall,
                  maxLines: 2,
                ),
                addVerticalSpace(context.screenHeight * 0.05),
                const Text(
                  'Email Address',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                addVerticalSpace(context.screenHeight * 0.01),
                TextField(
                  controller: _emailTextEditingController,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(hintText: 'example@adress.com'),
                ),
                addVerticalSpace(context.screenHeight * 0.03),
                _buildResetPasswordButton(),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return Consumer(
      builder: (context, ref, child) {
        final resetPasswordState = ref.watch(resetPasswordButtonControllerProvider);

        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: resetPasswordState is AsyncLoading<void>
                ? null
                : () {
                    if (_emailTextEditingController.text.isValidEmail) {
                      ref.read(resetPasswordButtonControllerProvider.notifier).resetPassword(
                            email: _emailTextEditingController.text.trim(),
                          );
                    } else {
                      HelperFunctions.showErrorSnackBar(message: 'Please enter a valid email.');
                    }
                  },
            child: resetPasswordState is AsyncLoading<void>
                ? SpinKitThreeBounce(
                    color: context.colorScheme.primary,
                    size: 25,
                  )
                : const Text('Reset Password'),
          ),
        );
      },
    );
  }
}
