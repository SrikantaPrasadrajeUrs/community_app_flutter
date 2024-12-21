import 'package:ecommerse_website/core/common/sign_in_button.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/themes/my_text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.watch(authControllerProvider.notifier).signInWithGoogle(context, false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title: Image.asset(Constants.logoPath,height: 60,color: Colors.green,)
      ),
      body: ListView(
        children: [
          reusableSizedBox(context, .02, true, false),
        const Center(child: Text("Dive Into Anything",style: MyTextThemes.mediumWhite,)),
          Image.asset(Constants.loginImage,height: 300,),
          SizedBox(
              width: size.width-32,
              child: const SignInBtn()),
        ],
      ),
    );
  }
}
