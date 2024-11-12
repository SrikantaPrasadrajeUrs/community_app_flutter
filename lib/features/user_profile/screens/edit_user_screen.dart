import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/user_profile/controller/user_profile_controller.dart';
import 'package:ecommerse_website/model/user_model.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class EditUserScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserScreen({super.key, required this.uid});
  @override
  ConsumerState<EditUserScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditUserScreen> {
  File? banner;
  File? profile;
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)?.name);
    super.initState();
  }

  Future<void> getBannerImage()async{
    var file = await pickImage();
    if(file!=null){
      setState(()=>banner = File(file.files.first.path!));
    }
  }

  Future<void> getProfileImage()async{
    var file = await pickImage();
    if(file!=null){
      setState(()=>profile = File(file.files.first.path!));
    }
  }

  void updateProfile(UserModel userModel,BuildContext context){
    String name = nameController.text.isEmpty?userModel.name:nameController.text;
     ref.read(userProfileControllerProvider.notifier).updateUserProfile(userModel,name,banner,profile,context);
  }

  @override
  Widget build(BuildContext context) {
    bool isSaving = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: true,
              actions: [TextButton(onPressed: () {
                updateProfile(user, context);
              }, child: const Text("Update"))
              ],
            ),
            body: Stack(
              children: [
                Column(
                children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: getBannerImage,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          borderPadding: const EdgeInsets.all(10),
                          strokeWidth: 3,
                          dashPattern: const [14, 12],
                          color: MyTheme.darkModeAppTheme.textTheme.bodyMedium!
                              .color!,
                          radius: const Radius.circular(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 190,
                            child: banner != null ? Padding(
                                padding: const EdgeInsets.all(25),
                                child: Image.file(banner!))
                                : Image.network(user.banner),
                          )),
                    ),
                    Positioned(
                      bottom: 10, left: 15,
                      child: GestureDetector(
                        onTap: getProfileImage,
                        child: profile != null ? CircleAvatar(
                          radius: 32,
                          backgroundImage: FileImage(profile!),
                        ) : CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                      ),
                    ),
                  ],
                ),
              Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            constraints: BoxConstraints(
                                maxHeight: 40,
                                maxWidth: MediaQuery.of(context).size.width
                            ),
                            hintText: "New user name?",
                            hintStyle: TextStyle(letterSpacing: 1.5)
                        ),
                      ),
                    ),
                ],
              ),if(isSaving) Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                  ),
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: const CenterLoader()
              ),]
            ),
          );
        },
        error: (e, st) => Scaffold(body: Center(child: Text(e.toString()))),
        loading: () => const Scaffold(body: CenterLoader()));
  }
}
