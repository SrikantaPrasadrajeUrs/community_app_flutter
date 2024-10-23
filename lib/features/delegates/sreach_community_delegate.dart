import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/features/community/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchCommunityDelegate extends SearchDelegate{
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
   return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(communityStreamProvider(query)).when(
        data: (communities){
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context,index){
              var community = communities[index];
              return ListTile(
                onTap: ()=>navigateToCommunityScreen(context,community.name),
                leading: CircleAvatar(
                  child: Image.network(community.avatar),
                ),
                title: Text("r/${community.name}"),
              );
            },
          );
        }, 
        error: (e,st)=>ErrorText(message:e.toString()), 
        loading:()=>const CenterLoader());
  }

  void navigateToCommunityScreen(BuildContext context,String name)=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommunityScreen(name:name)));
}