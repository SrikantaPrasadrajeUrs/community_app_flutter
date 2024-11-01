import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/features/community/screens/community_screen.dart';
import 'package:ecommerse_website/features/community/screens/create_community.dart';
import 'package:ecommerse_website/model/community_model/community_model.dart';
import 'package:ecommerse_website/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../themes/myThemes.dart';

class CommunityListDrawer extends ConsumerStatefulWidget {
  const CommunityListDrawer({super.key});

  @override
  ConsumerState<CommunityListDrawer> createState() => _CommunityListDrawerState();
}

class _CommunityListDrawerState extends ConsumerState<CommunityListDrawer> {

  late UserModel? userData;
  late final CommunityController communityController;

  @override
  void initState() {
     userData = ref.read(userProvider);
     communityController = ref.read(communityControllerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  var communities = ref.watch(userCommunityProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                navigateToCreateCommunity(context);
              },
              leading: const Icon(Icons.add),
              title: const Text("Create Collection"),
            ),
            communities.when(
              data: (communities) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      return _communityView(
                        community: communities[index],
                        uid: userData?.uid??"",
                        context: context,
                        ref: ref,
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeletePrompt(BuildContext context, String communityName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            "Are you sure?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            "This action cannot be undone. Do you wish to continue?",
            style: TextStyle(fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
          actions: [
            TextButton(
              onPressed: () {
                communityController.deleteCommunity(context, communityName: communityName);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: MyTheme.whiteColor.withOpacity(.8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToCommunityScreen(BuildContext context, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityScreen(name: name)),
    );
  }

  void navigateToCreateCommunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCommunity()),
    );
  }

  Widget _communityView({
    required Community community,
    required String uid,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return ListTile(
      onTap: () {
        navigateToCommunityScreen(context, community.name);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(community.avatar),
      ),
      title: Text(
        'r/${community.name}',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: uid == community.ownerId
          ? IconButton(
        onPressed: () {
          showDeletePrompt(context, community.name);
        },
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.orange,
        ),
      )
          : null,
    );
  }
}
