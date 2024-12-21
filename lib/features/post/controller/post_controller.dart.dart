import 'dart:io';
import 'package:ecommerse_website/core/providers/storage_repo_provider.dart';
import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/post/repository/post_repository.dart';
import 'package:ecommerse_website/model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../model/community_model/community_model.dart';

// instance of communityController
final postControllerProvider = StateNotifierProvider<PostController, bool>(
    (ref) => PostController(
        postRepository: ref.read(postRepositoryProvider),
        ref: ref,
        storageRepo: ref.read(storageRepoProvider)));

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepo _storageRepo;
  final Ref _ref;
  PostController(
      {required PostRepository postRepository,
      required StorageRepo storageRepo,
      required Ref ref})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  Future<void> _addPost({
    required BuildContext context,
    required Community community,
    required PostModel post,
  }) async {
    final response = await _postRepository.addPost(post);
    response.fold(
          (error) => showSnackBar(context, error.toString()),
          (success) {
        showSnackBar(context, 'Successfully Added');
        Navigator.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required Community community,
    required String link,
    required String title,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final post = PostModel(
      id: const Uuid().v1(),
      title: title,
      communityProfilePic: community.avatar,
      upVotes: 0,
      downVotes: 0,
      commentCount: 0,
      userName: user!.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      link: link,
      awards: [],
    );
    _addPost(context: context, community: community, post: post);
    state = false;
  }

  void shareImagePost({
    required BuildContext context,
    required Community community,
    required File? file,
    required String title,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final imageUrl = await _storageRepo.storeFile(
      path: 'users/${community.name}',
      name: const Uuid().v1(),
      file: file,
    );
    final imageUrlResult = imageUrl.fold(
          (error) => showSnackBar(context, error.message),
          (url){
            final post = PostModel(
              id: const Uuid().v1(),
              title: title,
              imageUrl: url,
              communityProfilePic: community.avatar,
              upVotes: 0,
              downVotes: 0,
              commentCount: 0,
              userName: user!.name,
              uid: user.uid,
              type: 'image',
              createdAt: DateTime.now(),
              awards: [],
            );
            _addPost(context: context, community: community, post: post);
          },
    );
    state = false;
  }

  void shareTextPost({
    required BuildContext context,
    required Community community,
    required String description,
    required String title,
  }) async {
    state = true;
    final user = _ref.read(userProvider);
    final post = PostModel(
      id: const Uuid().v1(),
      title: title,
      description: description,
      communityProfilePic: community.avatar,
      upVotes: 0,
      downVotes: 0,
      commentCount: 0,
      userName: user!.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
    );
    _addPost(context: context, community: community, post: post);
    state = false;
  }
}
