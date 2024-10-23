import 'dart:io';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/storage_repo_provider.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/model/community_model/community_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../repository/community_repository.dart';

// instance of communityController
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) =>
        CommunityController(
            communityRepository: ref.read(communityRepositoryProvider),
            ref: ref,
            storageRepo: ref.read(storageRepoProvider)));

// user Community
final userCommunityProvider = StreamProvider(
    (ref) => ref.read(communityControllerProvider.notifier).getCommunities());

//community by name
final getCommunityByName = StreamProvider.family((ref, String name) =>
    ref.watch(communityControllerProvider.notifier).getCommunityByName(name));

final communityStreamProvider = StreamProvider.family((ref,String query){
 return ref.read(communityControllerProvider.notifier).getCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepo _storageRepo;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository,
      required StorageRepo storageRepo,
      required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    Community community = Community(
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid],
        id: name);
    final res = await _communityRepository.createCommunity(community);
    res.fold(
        (failure) => {state = false, showSnackBar(context, failure.message)},
        (userModel) {
      state = false;
      showSnackBar(context, "${community.name} community created");
      Navigator.of(context).pop();
    });
  }

  Stream<List<Community>> getCommunities() {
    print('getting community');
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required Community community,
      required File? bannerImg,
      required File? profileImg,
      required BuildContext context}) async {
    try {
      state = true;
      if (bannerImg != null) {
        final url = await  _storageRepo.storeFile(path: "communities/banner", name: community.name, file: bannerImg);
        url.fold((e)=>showSnackBar(context, e.toString()), (url){
         community = community.copyWith(banner: url);
        });
      }
      if (profileImg != null) {
        final url = await  _storageRepo.storeFile(path: "communities/profile", name: community.name, file: profileImg);
        url.fold((e)=>showSnackBar(context, e.toString()), (url)=>community = community.copyWith(avatar: url));
      }
      final res = await _communityRepository.editCommunity(community);
      res.fold((e)=>showSnackBar(context, e.toString()), (r){
        showSnackBar(context, "Community updated!");
        Navigator.of(context).pop();
      });
      state = false;
    } catch (e) {
      showSnackBar(context, e.toString());
      Navigator.of(context).pop();
      state = false;
    }
  }

  Stream<List<Community>> getCommunity(String query){
    return _communityRepository.getCommunitiesByName(query).map((communities){
    return communities.where((community)=>community.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> joinCommunity(String communityName, String userId, List<String> members, BuildContext context) async {
    if (communityName.isEmpty || userId.isEmpty) {
      showSnackBar(context, "Invalid community or user.");
      return;
    }

    bool isMember = members.contains(userId);

    var response = isMember
        ? await _communityRepository.leaveCommunity(communityName, userId)
        : await _communityRepository.joinCommunity(communityName, userId);

    handleCommunityResponse(response, context, isMember ? "Community left" : "Community joined");
  }

  void handleCommunityResponse(Either<Failure,void> response, BuildContext context, String successMessage) {
    response.fold(
          (error) => showSnackBar(context, error.message),
          (data) => showSnackBar(context, successMessage),
    );
  }


}
