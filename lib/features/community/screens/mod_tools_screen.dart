import 'package:flutter/material.dart';

class ModToolScreen extends StatelessWidget {
  const ModToolScreen({super.key});

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
        ],
      ),
    );
  }
}
