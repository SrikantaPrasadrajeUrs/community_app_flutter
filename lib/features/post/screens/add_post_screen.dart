import 'package:ecommerse_website/core/enums/enums.dart';
import 'package:ecommerse_website/features/post/screens/add_post_type_screen.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: ()=>navigateToAddPostTypeScreen(context,PostType.image),
          child: getIcon(Icons.image,currentTheme.iconTheme.color!),
        ),
        GestureDetector(
          onTap: ()=>navigateToAddPostTypeScreen(context,PostType.text),
          child: getIcon(Icons.font_download_outlined,currentTheme.iconTheme.color!),
        ),
        GestureDetector(
          onTap: ()=>navigateToAddPostTypeScreen(context,PostType.link),
          child: getIcon(Icons.link,currentTheme.iconTheme.color!),
        ),
      ],
    );
  }

  void navigateToAddPostTypeScreen(BuildContext context,PostType postType)=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostTypeScreen(postType: postType)));

  Widget getIcon(IconData? iconData,Color iconColor){
    double cardSize = 100;
    double iconSize = 30;
    return  SizedBox(
      height: cardSize,
      width: cardSize,
      child: Card(
        elevation: 8,
        color: Colors.grey.withOpacity(.6),
        child: Icon(iconData,color:iconColor,size: iconSize,),
      ),
    );
  }
}
