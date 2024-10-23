import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/home/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/user_model.dart';
import '../repository/auth_repository.dart';

// Contains current user data
final userProvider = StateProvider<UserModel?>((ref) => null);
// a provider for authentication and state Change(changes state based on Type 1 is recieved or not)
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);
// a provider for keeping watch on authController state
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  //Provides access to other providers within the dependency tree.
  final Ref ref;
  final AuthRepository _authRepository;
  AuthController({required this.ref, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(false);

  // here user represents a user account a part of firebse auth
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = false;
    final userModelOrFailure = await _authRepository.signInWithGoogle(isFromLogin);
    userModelOrFailure.fold((failure) {
      state = false;
      showSnackBar(context, failure.message);
    }, (userModel) {
      state = true;
      ref.read(userProvider.notifier).update((state) => userModel);
      showSnackBar(context, "${userModel.name} logged in");
     Navigator.push(context,MaterialPageRoute(builder: (context)=> const HomePage()));
    });
    // l => Failure R=> Model
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logout()=>_authRepository.logout();
}
