import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/core/enums/enums.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/features/community/controller/community_controller.dart';
import 'package:ecommerse_website/model/community_model/community_model.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../controller/post_controller.dart.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final PostType postType;
  const AddPostTypeScreen({super.key,required this.postType});

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;
  Community? selectedCommunity;
  File? banner;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    linkController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(postControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    bool isText = widget.postType == PostType.text;
    bool isLink = widget.postType == PostType.link;
    bool isImage = widget.postType == PostType.image;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentTheme.appBarTheme.backgroundColor,
        title: Text('Post ${widget.postType.name}'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.share,color: currentTheme.iconTheme.color,))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      constraints: BoxConstraints(
                          maxHeight: 40,
                          maxWidth: MediaQuery.of(context).size.width
                      ),
                      hintText: "Enter title here",
                      hintStyle: const TextStyle(letterSpacing: 1.5)
                  ),
                ),
                if(isImage)GestureDetector(
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
                        child: banner != null ? Image.file(banner!):Icon(Icons.camera_alt_outlined),
                      )),
                ),
                const SizedBox(height: 10,),
                if(isText)TextField(
                  controller: descriptionController,
                  maxLength:100,
                  maxLines: 5,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Circular border radius
                        borderSide: const BorderSide(color: Colors.transparent), // Transparent border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Circular border radius
                        borderSide: const BorderSide(color: Colors.transparent), // Transparent border color
                      ),
                    filled: true,
                      hintText: "Enter description here",
                      hintStyle: const TextStyle(letterSpacing: 1.5)
                  ),
                ),
                if(isLink)TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                      hintText: "Enter link here",
                      hintStyle: TextStyle(letterSpacing: 1.5)
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ref.read(userCommunityProvider).when(
                    data: (data){
                      if(data.isEmpty) return const ErrorText(message: "No Communities");
                      return DropdownSearch(
                        items: (_,__)=>data.map((community)=>community.name).toList(),
                        onChanged: (val){
                            setState(()=>selectedCommunity = data.firstWhereOrNull((community)=>community.name==val));
                        },
                      );
                    },
                    error: (e,st){
                      return  const ErrorText(message: "No Communities");
                    },
                    loading: ()=>const CenterLoader()),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: handlePost,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentTheme.cardColor,
                    ),
                    child: const Center(child: Text('Post')),
                  ),
                )
              ],
            ),
          ),
          if(isLoading) Container(
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
  }

  void handlePost() async {
    final postType = widget.postType;
    final community = selectedCommunity;
    final title = titleController.text.trim();

    if (community == null || title.isEmpty){
      showSnackBar(context, 'Title or Community is blank!');
      return;
    }

    switch (postType) {
      case PostType.image:
        if (banner == null) return;
        ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          community: community,
          file: banner,
          title: title,
        );
        break;
      case PostType.link:
        final link = linkController.text.trim();
        if (link.isEmpty) return;
        ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          community: community,
          link: link,
          title: title,
        );
        break;
      case PostType.text:
        final description = descriptionController.text.trim();
        if (description.isEmpty) return;
        ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          community: community,
          description: description,
          title: title,
        );
        break;
    }
  }

  Future<void> getBannerImage()async{
    var file = await pickImage();
    if(file!=null){
      setState(()=>banner = File(file.files.first.path!));
    }
  }
}
