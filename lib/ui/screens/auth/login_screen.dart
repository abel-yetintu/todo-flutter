import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/controllers/login_button_controller.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/services/navigation_service.dart';
import '../../../core/dependecy_injection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
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
                  'Login',
                  style: context.textTheme.headlineSmall,
                ),
                addVerticalSpace(context.screenHeight * 0.01),
                Text(
                  "Welcome back! It's great to see you again.",
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
                        decoration: const InputDecoration(hintText: 'example@adress.com'),
                        validator: (value) {
                          if (value!.isValidEmail) {
                            return null;
                          } else {
                            return 'Enter a valid email';
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => getIt<NavigationService>().routeTo('/forgotPassword'),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: context.theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(context.screenHeight * 0.01),
                      TextFormField(
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) {
                          if (value == "") {
                            return "Enter password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      addVerticalSpace(context.screenHeight * 0.03),
                      _buildLoginButton(),
                    ],
                  ),
                ),
                addVerticalSpace(context.screenHeight * 0.03),
                Row(
                  children: [
                    const Text("Don't have an account? "),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getIt<NavigationService>().routeTo('/signUp');
                        },
                        child: Text(
                          "Register here",
                          maxLines: 1,
                          style: TextStyle(
                            color: context.theme.colorScheme.primary,
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

  Widget _buildLoginButton() {
    return Consumer(
      builder: (context, ref, child) {
        final loginState = ref.watch(loginButtonControllerProvider);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: loginState is AsyncLoading<void>
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(loginButtonControllerProvider.notifier).login(
                            email: _emailTextEditingController.text.trim(),
                            password: _passwordTextEditingController.text.trim(),
                          );
                    }
                  },
            child: loginState is AsyncLoading<void>
                ? SpinKitThreeBounce(
                    color: context.theme.colorScheme.tertiary,
                    size: 25,
                  )
                : const Text('Login'),
          ),
        );
      },
    );
  }
}
