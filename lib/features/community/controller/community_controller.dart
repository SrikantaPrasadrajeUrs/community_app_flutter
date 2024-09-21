import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/model/community_model/community_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../repository/community_repository.dart';

// instance of communityController
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) =>
        CommunityController(
            communityRepository: ref.watch(communityRepositoryProvider),
            ref: ref));

// user Community
final userCommunityProvider = StreamProvider(
    (ref) => ref.read(communityControllerProvider.notifier).getCommunities());

//community by name
final getCommunityByName=StreamProvider.family(
        (ref,String name) => ref.watch(communityControllerProvider.notifier).getCommunityByName(name));


class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
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
      state = true;
      showSnackBar(context, "${community.name} community created");
      context.pop();
    });
  }

  Stream<List<Community>> getCommunities() {
    print('getting community');
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }
  Stream<Community> getCommunityByName(String name){
    return _communityRepository.getCommunityByName(name);
  }
}
