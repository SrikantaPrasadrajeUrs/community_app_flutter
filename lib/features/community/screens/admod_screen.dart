import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/community_model/community_model.dart';

class AdModScreen extends ConsumerStatefulWidget {
  final String name;
  const AdModScreen({super.key,required this.name});

  @override
  ConsumerState<AdModScreen> createState() => _AdModScreenState();
}

class _AdModScreenState extends ConsumerState<AdModScreen> {
  Set<String> userIds = {};
  void addOrRemoveUserId(String uid,bool contains){
    if(!contains){
      userIds.remove(uid);
    }else{
      userIds.add(uid);
    }
    setState(() => userIds);
  }

  @override
  void initState() {
    ref.read(getCommunityByName(widget.name)).when(data: (community){
      userIds.addAll(community.mods);
    },error: (e,st){},loading: ()=>const CenterLoader());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return ref.watch(getCommunityByName(widget.name)).when(data: (community){
      return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: ()async{
               ref.read(communityControllerProvider.notifier).updateCommunityMods(userIds.toList(), community.name, context).then((_){
                 Navigator.of(context).pop();
               });
            }, child: const Text("Done"),)
          ],
        ),
        body: MemberList(community: community, userIds: userIds, onUserIdChanged: addOrRemoveUserId),
      );
    }, error: (e,stackTrace){
      return ErrorWidget(e);
    }, loading: ()=>const CenterLoader());
  }
}


class MemberList extends ConsumerWidget {
  final Community community;
  final Set<String> userIds;
  final Function(String, bool) onUserIdChanged;

  MemberList({
    Key? key,
    required this.community,
    required this.userIds,
    required this.onUserIdChanged,
  }) : super(key: key);

  List<String> members = [];

  bool get containsOwner =>community.members.contains(community.ownerId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    members = List.from(community.members);
    if(containsOwner){
      members.remove(community.ownerId);
    }
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final userData = ref.watch(getUserDataProvider(members[index]));
        return userData.when(
          data: (userData) {
            return CheckboxListTile(
              checkColor: Colors.green,
              fillColor: const WidgetStatePropertyAll(Colors.black),
              value: userIds.contains(userData.uid),
              onChanged: (val) {
                onUserIdChanged(userData.uid, val ?? false);
              },
              title: Text(userData.name),
            );
          },
          error: (e, stackTrace) {
            return const CenterLoader();
          },
          loading: () => const CenterLoader(),
        );
      },
    );
  }
}