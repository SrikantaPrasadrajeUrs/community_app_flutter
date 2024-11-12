import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/features/community/screens/edit_community_screen.dart';
import 'package:ecommerse_website/features/community/screens/mod_tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityScreen extends ConsumerWidget {
  final String? name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModToolsScreen(BuildContext context,String name){
    Navigator.push(context, MaterialPageRoute(builder:(context)=>ModToolScreen(name:name)));
  }

  void navigateToEditCommunityScreen(BuildContext context,String communityName){
    Navigator.push(context, MaterialPageRoute(builder:(context)=> EditCommunityScreen(name: name??"")));
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
                            Row(
                              children: [
                                const SizedBox(width: 17),
                                community.mods.contains(user.uid)
                                    ? GestureDetector(
                                  onTap: () {
                                    navigateToModToolsScreen(context,community.name);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 0),
                                            blurRadius: 6,
                                            spreadRadius: 7,
                                            color: Colors.white.withOpacity(.2)
                                          )
                                        ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white)
                                      ),
                                      child: const Text('Mod tools',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                )
                                    : GestureDetector(
                                  onTap: () {
                                    ref.read(communityControllerProvider.notifier).joinCommunity(community.name, user.uid,community.members,context);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: 10,
                                                color: Colors.white.withOpacity(.7)
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white)
                                      ),
                                      child: Text( community.members.contains(user.uid)? 'leave':'join')),
                                )
                              ],
                            )
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
        return ErrorText(message: error.toString());
      }, loading: () {
        return const CenterLoader();
      }),
    );
  }
}
