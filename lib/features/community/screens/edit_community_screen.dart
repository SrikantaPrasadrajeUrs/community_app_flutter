import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerse_website/core/utils.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../core/constants/constants.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});
  @override
  ConsumerState<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? banner;
  File? profile;
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
  
  @override
  Widget build(BuildContext context) {
      bool isSaving = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByName(widget.name)).when(
            data: (community) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Edit Community"),
                    centerTitle: true,
                    actions: [TextButton(onPressed: () {
                      ref.read(communityControllerProvider.notifier).editCommunity(community: community, bannerImg: banner, profileImg: profile, context: context);
                    }, child: const Text("Save"))],
                  ),
                  body: Stack(
                    children: [
                      GestureDetector(
                        onTap: getBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                            borderPadding: const EdgeInsets.all(10),
                            strokeWidth: 3,
                            dashPattern: const [14,12],
                            color:MyTheme.darkModeAppTheme.textTheme.bodyMedium!.color!,
                            radius: const Radius.circular(20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 190,
                              child: banner!=null? Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Image.file(banner!)):community.banner.isEmpty||community.banner == Constants.bannerDefault?  const Icon(Icons.camera_alt_outlined,size: 30):Image.network(community.banner),
                            )),
                      ),
                      Positioned(
                        bottom: 15,left: 15,
                        child: GestureDetector(
                          onTap: getProfileImage,
                          child:profile!=null? CircleAvatar(
                            radius: 32,
                            backgroundImage: FileImage(profile!),
                          ):CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                        ),
                      ),
                      if(isSaving) Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                        ),
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: const CenterLoader()
                      )
                    ],
                  ),
                );
            },
            error: (e, st) => Scaffold(body: Center(child: Text(e.toString()))),
            loading: () => const Scaffold(body: CenterLoader()));
  }
}
