import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/features/community/screens/community_screen.dart';
import 'package:ecommerse_website/features/community/screens/create_community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var communities = ref.watch(userCommunityProvider);
    // print("$communities <- communities");
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                navigateToCreateCommunity(context);
              },
              leading: const Icon(Icons.add),
              title: const Text("Create Collection"),
            ),
            communities.when(data: (communities) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: (){
                            navigateToCommunityScreen(context,communities[index].name);
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(communities[index].avatar),
                          ),
                          title: Text('r/${communities[index].name}'),
                        );
                      }));
            }, error: (object, stackTrace) {
              throw Exception(stackTrace);
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void navigateToCommunityScreen(BuildContext context,String name){
    Navigator.push(context, MaterialPageRoute(builder:(context)=>CommunityScreen(name: name)));
  }

  void navigateToCreateCommunity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder:(context)=>const CreateCommunity()));
  }
}

