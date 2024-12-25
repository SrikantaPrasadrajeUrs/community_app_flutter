import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/user_profile/screens/user_profile_screen.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../auth/screens/login_screen.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
  const ProfileDrawer({super.key});

  @override
  ConsumerState<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends ConsumerState<ProfileDrawer> {

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
          top: true,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user?.profilePic ?? user!.banner),
                radius: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user!.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Divider(
                endIndent: 10,
                indent: 10,
              ),
              ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfile(uid: user.uid)));
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              ListTile(
                onTap: () => logout(ref, context),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text("Logout"),
              ),
              Row(
                children: [
                  const SizedBox(width: 5,),
                  Switch.adaptive(
                     inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      activeThumbImage: const AssetImage('assets/images/sun.png'),
                      inactiveThumbImage: const AssetImage('assets/images/m.png'),
                      activeTrackColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.black26,
                      value: !(ref.watch(themeNotifierProvider.notifier).mode==ThemeMode.light),
                      onChanged: (val) {
                    ref.read(themeNotifierProvider.notifier).toggleTheme();
                  }),
                  // Text(ref.watch(themeNotifierProvider.notifier).mode==ThemeMode.light?" Light mode":" Dark mode",style: TextStyle(fontSize: 15),)
                ],
              ),
            ],
          )),
    );
  }

  void logout(WidgetRef ref, BuildContext context) async {
    await ref.read(authControllerProvider.notifier).logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(shouldLogin: false,)));
  }
}
