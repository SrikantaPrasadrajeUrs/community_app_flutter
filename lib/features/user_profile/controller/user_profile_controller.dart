import 'dart:io';
import 'package:ecommerse_website/core/providers/storage_repo_provider.dart';
import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/user_profile/repository/user_profile_repository.dart';
import 'package:ecommerse_website/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController,bool>((ref)=>
    UserProfileController(
        ref: ref,
        userProfileRepository: ref.read(userRepositoryProvider),
        storageRepo: ref.read(storageRepoProvider)));

class UserProfileController extends StateNotifier<bool> {
  final StorageRepo _storageRepo;
  final Ref _ref;
  final UserProfileRepository _userProfileRepository;

  UserProfileController({required UserProfileRepository userProfileRepository,required StorageRepo storageRepo,required Ref ref})
      :_userProfileRepository=userProfileRepository,_storageRepo = storageRepo,_ref = ref, super(false);

  void updateUserProfile(UserModel userModel,String name,File? banner,File? profile,BuildContext context)async{
    state = true;
    // Update banner image if available
    userModel = await _uploadFileAndUpdateUser(
      path: 'users/banner',
      file: banner,
      name: '$name/${userModel.uid}',
      context: context,
      userModel: userModel,
      updateCallback: (url) => userModel.copyWith(banner: url),
      errorMessage: "Error uploading banner!",
    );

    // Update profile image if available
    userModel = await _uploadFileAndUpdateUser(
      path: 'users/profile',
      file: profile,
      name: '$name/${userModel.uid}',
      context: context,
      userModel: userModel,
      updateCallback: (url) => userModel.copyWith(profilePic: url),
      errorMessage: "Error uploading profile image!",
    );
   final response = await _userProfileRepository.updateUser(userModel);
   state = false;
   response.fold((failure){
     showSnackBar(context, "Some error occurred!");
   },(success){
     showSnackBar(context, "Profile updated!");
     _ref.read(userProvider.notifier).update((state)=>userModel);
     if(mounted) Navigator.of(context).pop();
   },);
  }

  Future<UserModel> _uploadFileAndUpdateUser({required String path,
    required File? file,
    required String name,
    required BuildContext context,
    required UserModel userModel,
    required UserModel Function(String url) updateCallback,
    required String errorMessage,})async{
    if (file == null) return userModel;

    final response = await _storageRepo.storeFile(
      path: path,
      name: name,
      file: file,
    );

    return response.fold(
          (failure) {
        showSnackBar(context, errorMessage);
        return userModel;
      },
          (url) => updateCallback(url),
    );
  }
}