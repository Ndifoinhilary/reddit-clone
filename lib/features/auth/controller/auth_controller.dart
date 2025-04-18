import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_models.dart';

final userProvider = StateProvider<UserModels?>((ref) => null);

/// This file contains the AuthController class and its provider.
final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref,
      super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  Stream<UserModels> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
