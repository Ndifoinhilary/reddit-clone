import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  /// This widget is a sign-in button that allows users to sign in with Google.
  /// It uses the [ConsumerWidget] to access the provider and build the UI.
  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () {
          signInWithGoogle(context, ref);
        },
        icon: Image.asset(Constants.googlePath, width: 30),
        label: const Text(
          "Sign in with Google",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Pallete.whiteColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
