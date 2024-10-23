import 'package:flutter/material.dart';

import 'edit_community_screen.dart';

class ModToolScreen extends StatelessWidget {
  final String name;
  const ModToolScreen({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading:const Icon(Icons.add_moderator),
            title:const Text("Add Moderators"),
            onTap: (){},
          ),
          ListTile(
            leading:const Icon(Icons.edit),
            title:const Text("Edit Community"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=> EditCommunityScreen(name: name??"")));
            },
          ),
        ],
      ),
    );
  }
  //navigateToEditCommunityScreen(context,community.name);
}
