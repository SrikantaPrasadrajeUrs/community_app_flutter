import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../drawer/community_list_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return user==null?const Scaffold(body: CenterLoader()):Scaffold(
      drawer: const CommunityListDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic.toString()),
            ),
          )
        ],
        leading: Builder(builder: (context) {
          // provide new context
          return IconButton(
            onPressed: () =>
              displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        title: const Text("Home"),
      ),
      body: Center(
        child: Text(user.name ?? ''),
      ),
    );
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
