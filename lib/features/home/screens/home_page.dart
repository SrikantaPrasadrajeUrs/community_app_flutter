import 'package:ecommerse_website/core/constants/constants.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/delegates/sreach_community_delegate.dart';
import 'package:ecommerse_website/features/home/drawer/profile_drawer.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../drawer/community_list_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
 int _page = 0;

 void handleExitApp()=>SystemNavigator.pop();

 void showExitDialog(BuildContext context) {
   showDialog(
     context: context,
     builder: (context) {
       return AlertDialog(
         content: const Text(
           "Are you sure you want to exit the application?",
           style: TextStyle(fontSize: 16),
         ),
         actions: [
           TextButton(
             onPressed: () {
               Navigator.of(context).pop(); // Close the dialog
             },
             child: const Text(
               'Cancel',
               style: TextStyle(color: Colors.grey),
             ),
           ),
           TextButton(
             onPressed:handleExitApp,
             child: const Text(
               'Exit',
               style: TextStyle(color: Colors.red),
             ),
           ),
         ],
       );
     },
   );
 }

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
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result){
          if(true){
            showExitDialog(context);
          }
        },
        child: Stack(
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
      ),
    );
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context)=> Scaffold.of(context).openEndDrawer();
}
