import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/core/common/center_loader.dart';
import 'package:ecommerse_website/features/user_profile/screens/edit_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends ConsumerWidget {
  final String uid;
  const UserProfile({super.key, required this.uid});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (userData) {
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
                            userData.banner,
                            fit: BoxFit.cover,
                          )),
                        ],
                      )),
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData.profilePic),
                            radius: 30,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'u/${userData.name}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 0),
                                                blurRadius: 10,
                                                color: Colors.white.withOpacity(.7))
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border:const Border(bottom: BorderSide(color: Colors.white))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${userData.karma}"),
                                          const Text(' ⭐️')
                                        ],
                                      ))
                                ]),
                            InkWell(
                              onTap: ()=>navigateToEditProFile(userData.uid,context),
                              child: Container(
                                  margin: const EdgeInsets.only(right: 10,top: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(.6),
                                          blurRadius: 010,
                                          offset: const Offset(2, 4)
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.blue)),
                                  child: const Text("Edit profile")),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ];
              },
              body: const Column(
                children: [
                   SizedBox(width: 10,),
                   Divider(),
                ],
              ),
            );
          },
          error: (e, st) {
            return ErrorText(message: e.toString());
          },
          loading: () => const CenterLoader()),
    );
  }
  
  void navigateToEditProFile(String uid,BuildContext context)=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditUserScreen(uid: uid)));
}
