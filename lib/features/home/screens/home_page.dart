import 'package:ecommerse_website/core/constants/constants.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/delegates/sreach_community_delegate.dart';
import 'package:ecommerse_website/features/home/drawer/profile_drawer.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../drawer/community_list_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
 int _page = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      endDrawer: const ProfileDrawer(),
      drawer: const CommunityListDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic.toString()),
                ),
              );
            }
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        title: const Text("Home"),
      ),
      body: Stack(
        children: [
          Constants.homeWidgets[_page],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CupertinoTabBar(
                  backgroundColor: currentTheme.bottomAppBarTheme.color,
                  activeColor: Colors.white,
                  currentIndex: _page,
                  height:70,
                  onTap: (index){
                    setState(() {
                      _page = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_sharp)),
                    BottomNavigationBarItem(icon: Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context)=> Scaffold.of(context).openEndDrawer();
}
