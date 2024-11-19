import 'package:ecommerse_website/features/feeds/screens/post_feeds_screen.dart';
import 'package:ecommerse_website/features/post/screens/add_post_screen.dart';
import 'package:flutter/material.dart';

class Constants{
  static const logoPath='assets/logo.png';
  static const loginEmotePath='assets/loginEmote.png';
  static const googlePath='assets/google.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';
  static const homeWidgets = [
    PostFeedsScreen(),
    AddPostScreen()
  ];
}
SizedBox reusableSizedBox(
    BuildContext context, double ratio, bool height, bool width,
    [Widget? child, double? widthRatio]) {
  Size size = MediaQuery.of(context).size;

  if (height && width && child != null&&widthRatio!=null) {
    return SizedBox(
      height: size.height * ratio,
      width: size.width * widthRatio,
      child: child,
    );
  } else if (height && width && widthRatio!=null) {
    return SizedBox(
      height: size.height * ratio,
      width: size.width * widthRatio,
    );
  } else if (height) {
    return SizedBox(height: size.height * ratio);
  } else if(width&&widthRatio!=null){
    return SizedBox(width: size.width * widthRatio);
  }else{
    print("empty SizedBox sent!!");
    return const SizedBox();
  }
}