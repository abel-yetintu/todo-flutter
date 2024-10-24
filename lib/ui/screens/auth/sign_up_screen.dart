import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/controllers/sign_up_button_controller.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/services/navigation_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameTextEditingController;
  late TextEditingController _userNameTextEditingController;
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  late TextEditingController _confirmPasswordTextEditingController;

  @override
  void initState() {
    super.initState();
    _nameTextEditingController = TextEditingController();
    _userNameTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _confirmPasswordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _userNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05, vertical: 0),
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              children: [
                Text(
                  'Create an account',
                  style: context.textTheme.headlineSmall,
                ),
                addVerticalSpace(context.screenHeight * 0.01),
                Text(
                  "Ready to get started? Let's create your account.",
                  style: context.textTheme.bodySmall,
                  maxLines: 1,
                ),
                addVerticalSpace(context.screenHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _nameTextEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(hintText: 'John Doe'),
                        validator: (value) {
                          if (value!.isValidName) {
                            return null;
                          } else {
                            return "Enter a valid name";
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      const Text(
                        'User Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _userNameTextEditingController,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(hintText: 'john.doe'),
                        validator: (value) {
                          if (value!.isValidUserName) {
                            return null;
                          } else {
                            return "Enter a valid user name";
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      const Text(
                        'Email Address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(hintText: 'example@address.com'),
                        validator: (value) {
                          if (value!.isValidEmail) {
                            return null;
                          } else {
                            return 'Enter a valid email';
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) {
                          if (value!.isValidPassword) {
                            return null;
                          } else {
                            return "Password must be at least 6 characters";
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      const Text(
                        'Confirm Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _confirmPasswordTextEditingController,
                        obscureText: true,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) {
                          if (_passwordTextEditingController.text == _confirmPasswordTextEditingController.text) {
                            return null;
                          } else {
                            return 'Passwords do not match';
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      _buildSignUpButton(),
                    ],
                  ),
                ),
                addVerticalSpace(context.screenHeight * 0.03),
                Row(
                  children: [
                    const Text("Already have an account? "),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getIt<NavigationService>().goBack();
                        },
                        child: Text(
                          "Sign in here",
                          maxLines: 1,
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Consumer(
      builder: (context, ref, child) {
        final signUpState = ref.watch(signUpButtonControllerProvier);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: signUpState is AsyncLoading<void>
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(signUpButtonControllerProvier.notifier).signUp(
                            email: _emailTextEditingController.text.trim(),
                            userName: _userNameTextEditingController.text.trim(),
                            password: _passwordTextEditingController.text.trim(),
                            fullName: _nameTextEditingController.text.trim(),
                          );
                    }
                  },
            child: signUpState is AsyncLoading<void>
                ? SpinKitThreeBounce(
                    color: context.colorScheme.tertiary,
                    size: 25,
                  )
                : const Text('Sign Up'),
          ),
        );
      },
    );
  }
}
