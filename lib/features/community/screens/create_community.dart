import 'package:ecommerse_website/core/constants/constants.dart';
import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../themes/my_text_themes.dart';
import '../controller/community_controller.dart';

class CreateCommunity extends ConsumerStatefulWidget {
  const CreateCommunity({super.key});

  @override
  ConsumerState<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends ConsumerState<CreateCommunity> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void createCommunity() {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == ' ') {
      showSnackBar(context, textEditingController.text.trim());
    } else {
      ref
          .watch(communityControllerProvider.notifier)
          .createCommunity(textEditingController.text.trim(), context);
    }
    ref.watch(communityControllerProvider.notifier).getCommunities();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading=ref.watch(communityControllerProvider);
    return isLoading? const CenterLoader():Scaffold(
      appBar: AppBar(
        title: const Text("Create Communities"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reusableSizedBox(context, .01, true, false),
            const Text("Community name"),
            reusableSizedBox(context, .01, true, false),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                fillColor: Theme.of(context).canvasColor,
                filled: true,
                hintText: "r/Enter Community name",
                hintStyle: const TextStyle(fontSize: 15),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLength: 21,
            ),
            reusableSizedBox(context, .01, true, false),
            ElevatedButton(
              onPressed: createCommunity,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Create community",
                style: MyTextThemes.mediumWhite.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
