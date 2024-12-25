import 'package:ecommerse_website/core/common/center_loader.dart';
import 'package:ecommerse_website/core/common/sign_in_button.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/themes/my_text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';


class LoginScreen extends ConsumerStatefulWidget {
  final bool shouldLogin;
  const LoginScreen({super.key, required this.shouldLogin});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async{
    if(widget.shouldLogin) _signIn();
    });
    super.initState();
  }

  Future<void> _signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await ref
          .watch(authControllerProvider.notifier)
          .signInWithGoogle(context, false);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body:  Stack(
        children: [
          ListView(
            children: [
              reusableSizedBox(context, .02, true, false),
              Center(child: Text("Find Your Tribe, Share Your Vibe",style: MyTextThemes.mediumWhite.copyWith(fontSize: 17),)),
              Image.asset(Constants.loginImage,height: 300,),
              SizedBox(
                  width: size.width-32,
                  child: const SignInBtn()),
            ],
          ),
          if(isLoading) const CenterLoader(bgColor: Colors.black45,)
        ],
      ),
    );
  }
}
