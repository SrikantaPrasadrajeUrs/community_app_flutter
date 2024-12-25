import 'package:ecommerse_website/core/common/post_card.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/features/post/controller/post_controller.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/center_loader.dart';

class PostFeedsScreen extends ConsumerStatefulWidget {
  const PostFeedsScreen({super.key});

  @override
  ConsumerState<PostFeedsScreen> createState() => _PostFeedsScreenState();
}

class _PostFeedsScreenState extends ConsumerState<PostFeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userCommunityProvider).when(
        data: (communities){
          return ref.watch(userPostProvider(communities)).when(
              data: (posts)=>ListView.builder(
                  itemCount: posts.length+1,
                  itemBuilder: (context,index){
                    if(index==posts.length) return const SizedBox(height: 200,);
                    return PostCard(post: posts[index]);
                  }
              ),
              error: (e, st) =>Center(child: Text(e.toString())),
              loading: () => const CenterLoader()
          );
        },
        error: (e, st) =>Center(child: Text(e.toString())),
        loading: () => const CenterLoader());
  }
}
