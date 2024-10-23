import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(userProvider);
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
              const ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
              ),
              ListTile(
                onTap: () => logout(ref, context),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text("Logout"),
              ),
              Switch.adaptive(value: true, onChanged: (val) {})
            ],
          )),
    );
  }

  void logout(WidgetRef ref, BuildContext context) async {
    await ref.read(authControllerProvider.notifier).logout();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
