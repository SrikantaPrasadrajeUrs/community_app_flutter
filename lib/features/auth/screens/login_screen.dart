import 'package:ecommerse_website/core/common/sign_in_button.dart';
import 'package:ecommerse_website/themes/my_text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    Size size=MediaQuery.of(context).size;
    // final bool isLoading=ref.watch(authControllerProvider.notifier).state;
    // print(isLoading.toString()+ " => authcontroller state");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Constants.logoPath,height: 60,),
        actions: [
          TextButton(onPressed: (){}, child: const Text("Skip",style: MyTextThemes.smallBlue,)),
          // reusableSizedBox(context, .001, false, true,null,.02),
        ],
      ),
      body: ListView(
        children: [
          reusableSizedBox(context, .02, true, false),
        const Center(child: Text("Dive Into Anything",style: MyTextThemes.mediumWhite,)),
          reusableSizedBox(context, .02, true, false),
          Center(child: reusableSizedBox(context, .35, true, true,Image.asset(Constants.loginEmotePath,fit: BoxFit.cover,),.83)),
          reusableSizedBox(context, .04, true, false),
          SizedBox(
              width: size.width-30,
              child: const SignInBtn()),
        ],
      ),
    );
  }
}
