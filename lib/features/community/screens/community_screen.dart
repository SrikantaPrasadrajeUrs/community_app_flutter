import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends ConsumerWidget {
  final String? name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModToolsScreen(BuildContext context){
    context.push("/mod-tools");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByName(name!)).when(data: (community) {
        return NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                    expandedHeight: 150,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        )),
                      ],
                    )),
                SliverPadding(
                  padding:const EdgeInsets.all(15),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                          radius: 30,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                                    onPressed: () {
                                      navigateToModToolsScreen(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 22),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    child: const Text('mod tools'),
                                  )
                                : OutlinedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 27),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    child: Text( community.members.contains(user.uid)? 'joined':'join'),
                                  ),
                          ]),
                      Text('${community.members.length} members')
                    ]),
                  ),
                ),
              ];
            },
            body: Center(
              child: Text(name!),
            ));
      }, error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      }, loading: () {
        return const CenterLoader();
      }),
    );
  }
}
